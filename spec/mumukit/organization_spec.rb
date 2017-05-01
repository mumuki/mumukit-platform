require_relative '../spec_helper'

describe Mumukit::Platform::Organization do
  let(:organization) { struct name: 'sample' }

  describe '#current' do
    context 'when switched' do
      before { Mumukit::Platform::Organization.switch! organization }
      it { expect(Mumukit::Platform::Organization.current).to eq organization }
    end
    context 'when not switched' do
      before { Mumukit::Platform::Organization.leave! }
      it { expect { Mumukit::Platform::Organization.current }.to raise_error }

    end

  end
end
