require "./lib/freeagent_til/version"
require "git"
require "fileutils"
require "tty-markdown"
require "thor"

module FreeagentTIL
	REPO_PATH = File.expand_path("~/.cache/")
	REPO_NAME = "freeagent_til"
	GITHUB_REPO_URL = "https://github.com/fac/TIL"
	REJECT_LIST = [".", "..", ".git", ".DS_Store", "README.md"]

	class Error < StandardError; end

	class Runner
		def self.exit_on_failure?
		  true
		end

		def self.find(til_area: nil, exact_til: nil)
			runner = new()
			til_area ||= runner.til_areas.sample
			til_snippet ||= runner.til_entries_for(til_area).sample

			path_to_entry = runner.til_entry_for(til_area, til_snippet)

			title = TTY::Markdown.parse("# TIL: #{til_area} - #{til_snippet}")
			body = TTY::Markdown.parse_file(path_to_entry)
			return "\n#{title}\n" + body + "\n"
		end

		def full_path
			File.join(REPO_PATH, REPO_NAME)
		end

		def til_areas
			return [] if !Dir.exists?(full_path)
			Dir.entries(full_path).reject { |folder| REJECT_LIST.include?(folder) }
		end

		def til_entries_for(til_area)
			path = File.join(full_path, til_area)
			Dir.entries(path).reject { |folder| REJECT_LIST.include?(folder) }
		end

		def til_entry_for(til_area, til_snippet)
			File.join(full_path, til_area, til_snippet)
		end

		def entries_for_area
			Dir.entries(File.join(full_path, til_area)).reject do |folder|
				REJECT_LIST.include?(folder)
			end
		end
	end

	class Setup
		def self.update_cache
			full_path = File.join(FreeagentTIL::REPO_PATH, FreeagentTIL::REPO_NAME)

			if Dir.exists?(full_path)
				git = Git.open(full_path)
				puts git.fetch
				puts git.pull
			else
				puts "cloning the FreeAgent TIL repo into ~/.cache"
				puts "run freeagent_til update to get new changes"

				Git.clone("git@github.com:fac/TIL.git", FreeagentTIL::REPO_NAME, path: FreeagentTIL::REPO_PATH)
			end
		end
	end

	class CLI < Thor
		setup = Dir.exists?(File.join(FreeagentTIL::REPO_PATH, FreeagentTIL::REPO_NAME))

		unless setup
			desc "setup", "setup the FreeAgent TIL CLI"
			def setup
				FreeagentTIL::Setup.update_cache
			end
		else
			desc "hidden setup", "setup is complete already", :hide => true
			def setup
				puts "you're already setup. Try these commands instead:"
				puts "freeagent_til"
				puts "freeagent_til rand"
			end

			runner = FreeagentTIL::Runner.new
			til_areas = runner.til_areas
			desc "update", "update the FreeAgent TIL repo"
			def update
				FreeagentTIL::Setup.update_cache
			end


			desc "rand", "get a random TIL from the FreeAgent TIL repo"
			def rand
				puts FreeagentTIL::Runner.find
			end

			til_areas.each do |command|
				desc "#{command}", "Get a TIL about #{command}"

				define_method("#{command}") do |*arguments|
					first_arg = arguments[0]
					second_arg = arguments[1]

					entries_for_area = runner.til_entries_for(command)

					if first_arg == "rand" || first_arg.nil?
						puts FreeagentTIL::Runner.find(til_area: command)
					elsif first_arg == "--edit"
						puts GITHUB_REPO_URL + "/blob/master/#{command}"
					elsif first_arg == "--new"
						puts GITHUB_REPO_URL + "/new/master/#{command}"
					elsif first_arg == "list"
						puts entries_for_area
					elsif entries_for_area.include?(first_arg)
						if second_arg == "--edit"
							puts GITHUB_REPO_URL + "/blob/master/#{command}/#{first_arg}"
						else
							puts FreeagentTIL::Runner.find(til_area: command, exact_til: first_arg)
						end
					end
				end
			end
		end
	end
end
