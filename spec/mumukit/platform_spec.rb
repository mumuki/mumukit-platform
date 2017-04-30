require_relative '../spec_helper'

describe Mumukit::Platform do
  it 'has a version number' do
    expect(Mumukit::Platform::VERSION).not_to be nil
  end
end
