require_relative '../spec_helper'

describe Mumukit::Platform::Locale do
  it { expect(Mumukit::Platform::Locale.supported).to eq %w(en es pt) }
end
