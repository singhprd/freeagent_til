require "./lib/tldr/version"

module Tldr
  class Error < StandardError; end

  class Runner
	  def self.hello_world
	  	return "hello world"
	  end
  end
end
