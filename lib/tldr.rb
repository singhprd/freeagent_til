require "./lib/tldr/version"
require "git"
require 'fileutils'
require 'tty-markdown'
require "thor"

module Tldr
	REPO_PATH = File.expand_path('~/.cache/')
	REPO_NAME = "freeagent_til"
	REJECT_LIST = [".", "..", ".git", ".DS_Store"]

	class Error < StandardError; end

	class CLI < Thor
		desc "rand", "get a random TIL from FreeAgent"
		def rand
			puts Tldr::Runner.random_entry
		end

		til_areas = Dir.entries(File.join(REPO_PATH, REPO_NAME)).reject { |folder| REJECT_LIST.include?(folder) }

		til_areas.each do |command|
			desc "#{command}", "Get a TIL about #{command}"

			define_method("#{command}") do |*arguments|
				first_arg = arguments.first
				entries_for_area = Tldr::Runner.new.til_entries_for(command)

				if first_arg == "rand" || first_arg.nil?
					puts Tldr::Runner.random_entry(til_area: command)
				elsif first_arg == "list"
					puts entries_for_area
				elsif entries_for_area.include?(first_arg)
					puts Tldr::Runner.random_entry(til_area: command, exact_til: first_arg)
				end
			end
		end
	end

	class Setup
		def full_path
			File.join(REPO_PATH, REPO_NAME)
		end

		def self.update_cache
			if Dir.exists?(FULL_PATH)  		
				git = Git.open(full_path)
				git.fetch
				git.pull
			else
				Git.clone('git@github.com:fac/TIL.git', REPO_NAME, path: REPO_PATH)
			end
		end
	end

	class Runner
		def self.random_entry(til_area: nil, exact_til: nil)
			runner = new()
			til_area ||= runner.til_areas.sample
			til_snippet ||= runner.til_entries_for(til_area).sample

			path_to_entry = runner.til_entry_for(til_area, til_snippet)

			title = TTY::Markdown.parse("# FreeAgent TIL O'the day: #{til_area} - #{til_snippet}", width: 60)
			body = TTY::Markdown.parse_file(path_to_entry, width: 60)
			return "\n#{title}\n" + body + "\n"
		end

		def self.fetch_entry(til_area, til_snippet)
			path_to_entry = new().til_entry_for(til_area, til_snippet)
			title = "# FreeAgent TIL O'the day: #{til_area} #{til_snippet}"
			body = File.open(path_to_entry)

			tty_message(title, body)
		end

		def full_path
			File.join(REPO_PATH, REPO_NAME)
		end

		def til_areas
			Dir.entries(full_path).reject { |folder| REJECT_LIST.include?(folder) }
		end

		def til_entries_for(til_area)
			path = File.join(full_path, til_area)
			Dir.entries(path).reject { |folder| REJECT_LIST.include?(folder) }
		end

		def til_entry_for(til_area, til_snippet)
			path_to_entry = File.join(full_path, til_area, til_snippet)
			path_to_entry
		end

		def entries_for_area
			Dir.entries(File.join(full_path, til_area)).reject do |folder|
				REJECT_LIST.include?(folder)
			end
		end
	end
end
