require "spec_helper"

RSpec.describe Mumukit::Platform do
  it "has a version number" do
    expect(Mumukit::Platform::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
