RSpec.describe Tldr do
  it "has a version number" do
    expect(Tldr::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(Tldr::Runner.hello_world).to eq("hello world")
  end
end
