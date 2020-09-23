require "./lib/tldr/version"
require "git"
require 'fileutils'
require 'tty-markdown'

module Tldr
  REPO_PATH = File.expand_path('~/.cache/')
  REPO_NAME = "freeagent_til"
  REJECT_LIST = [".", "..", ".git"]

  class Error < StandardError; end

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
	  def self.fetch_entry(til_area, til_snippet)
	  	path_to_entry = new().til_entry_for(til_area, til_snippet)

	  	title = TTY::Markdown.parse("# FreeAgent TIL O'the day: Spotlight")
	  	parsed = TTY::Markdown.parse_file(path_to_entry)
	  	return "-------\n\n#{title}\n\n" + parsed + "\n-------\n\n"
	  end

  	def full_path
  		File.join(REPO_PATH, REPO_NAME)
  	end

	  def til_areas
	  	Dir.entries(full_path).reject { |folder| REJECT_LIST.include?(folder) }
	  end

	  def til_entry_for(til_area, til_snippet)
	  	entries = Dir.entries(File.join(full_path, til_area)).reject { |folder| REJECT_LIST.include?(folder) }

	  	path_to_entry = File.join(full_path, til_area, til_snippet)
	  	path_to_entry
	  end
  end
end
