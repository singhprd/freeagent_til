RSpec.describe Tldr do
	describe "exe/tldr" do
	  it "outputs something" do
	  	output = `exe/tldr`

	    expect(output).to include
	    	"tldr rand            # get a random TIL from FreeAgent"
	  end
	end

	describe Tldr do
		before(:each) do
			stub_const("Tldr::REPO_PATH", "spec/fixtures")
		end

	  it "has a version number" do
	    expect(Tldr::VERSION).not_to be nil
	  end

	  it "it has a stubbed path for the tests" do
	    expect(Tldr::REPO_PATH).to eq("spec/fixtures")
	  end

	  describe "Tldr::Runner#random_entry" do
	  	it "outputs a random TIL entry" do
		  	output = Tldr::Runner.random_entry
		  	expect(output).to include "An example TIL entry"
		  end
	  end
	end
end
