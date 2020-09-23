RSpec.describe Tldr do
	before(:each) do
		stub_const("Tldr::REPO_PATH", "spec/fixtures")
	end

  it "has a version number" do
    expect(Tldr::VERSION).not_to be nil
  end

  it "it has a path" do
    expect(Tldr::REPO_PATH).to eq("spec/fixtures")
  end

  it "does something useful" do
  	output = Tldr::Runner.fetch_entry("example_area", "example_til.md")

    expect(output).to include "FreeAgent TIL O’the day: Spotlight"
    expect(output).to include "An example TIL entry"
    expect(output).to include "This contains lots of useful information!"
  end
end
