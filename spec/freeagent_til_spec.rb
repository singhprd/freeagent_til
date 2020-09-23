RSpec.describe FreeagentTIL do
	describe "exe/freeagent_til" do
	  it "outputs something" do
	  	output = `exe/freeagent_til`

	    expect(output).to include
	    	"tldr rand            # get a random TIL from FreeAgent"
	  end
	end

	describe FreeagentTIL do
		before(:each) do
			stub_const("FreeagentTIL::REPO_PATH", "spec/fixtures")
		end

	  it "has a version number" do
	    expect(FreeagentTIL::VERSION).not_to be nil
	  end

	  it "it has a stubbed path for the tests" do
	    expect(FreeagentTIL::REPO_PATH).to eq("spec/fixtures")
	  end

	  describe "FreeagentTIL::Runner#random_entry" do
	  	it "outputs a random TIL entry" do
		  	output = FreeagentTIL::Runner.find
		  	expect(output).to include "An example TIL entry"
		  end
	  end
	end
end
