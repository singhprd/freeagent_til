RSpec.describe Tldr do
	before(:each) do
		stub_const("Tldr::REPO_PATH", "spec/fixtures")
	end

  # it "has a version number" do
  #   expect(Tldr::VERSION).not_to be nil
  # end

  it "does something useful" do
    expect(Tldr::Runner.fetch_entry).to eq("hello world")
  end

  it "it has a path" do
    expect(Tldr::REPO_PATH).to eq("spec/fixtures")
  end
end
