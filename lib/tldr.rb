require "./lib/tldr/version"
require "git"
require 'fileutils'
require 'tty-markdown'

module Tldr
  REPO_PATH = File.expand_path('~/.cache/')
  REPO_NAME = "freeagent_til"
  FULL_PATH = File.join(REPO_PATH, REPO_NAME)
  REJECT_LIST = [".", "..", ".git"]

  class Error < StandardError; end

  class Setup
  	def self.update_cache
			if Dir.exists?(FULL_PATH)  		
				g = Git.open(Tldr::FULL_PATH)
				g.fetch
				g.pull
			else
  			Git.clone('git@github.com:fac/TIL.git', REPO_NAME, path: REPO_PATH)
			end
  	end
  end

  class Runner
	  def self.fetch_entry
	  	new().get_page
	  end

	  def til_areas
	  	Dir.entries(Tldr::FULL_PATH).reject { |folder| REJECT_LIST.include?(folder) }
	  end

	  def til_entry_for(til_area, til_snippet)
	  	entries = Dir.entries(File.join(Tldr::FULL_PATH, til_area)).reject { |folder| REJECT_LIST.include?(folder) }

	  	path_to_entry = File.join(Tldr::FULL_PATH, til_area, til_snippet)
	  	path_to_entry
	  end

	  def get_page
	  	title = TTY::Markdown.parse("# FreeAgent TIL O'the day: Spotlight")
	  	parsed = TTY::Markdown.parse_file(til_entry_for("OS X", "spotlight.md"))
	  	puts "\n\n#{title}\n\n"
	  	puts parsed
	  end
  end
end
