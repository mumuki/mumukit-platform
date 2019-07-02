require_relative '../spec_helper'

class DemoUser
end

describe 'user_class' do
  before { Mumukit::Platform.config.user_class = nil }

  context 'when no user_class set' do
    it { expect { Mumukit::Platform.user_class }.to raise_error 'You must configure your user class first' }
  end

  context 'when user_class set' do
    before { Mumukit::Platform.config.user_class = DemoUser }

    it { expect(Mumukit::Platform.user_class).to eq DemoUser }
  end

  context 'when user_class_name set' do
    before { Mumukit::Platform.config.user_class_name = 'DemoUser' }

    it { expect(Mumukit::Platform.user_class).to eq DemoUser }
  end
end
