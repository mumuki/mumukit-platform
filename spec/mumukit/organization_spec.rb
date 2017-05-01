require_relative '../spec_helper'

describe Mumukit::Platform::Organization do
  let(:organization) { struct name: 'sample' }

  describe '#current' do
    context 'when switched' do
      before { Mumukit::Platform::Organization.switch! organization }
      it { expect(Mumukit::Platform::Organization.current).to eq organization }
      it { expect(Mumukit::Platform.current_organization_name).to eq 'sample' }
    end
    context 'when not switched' do
      before { Mumukit::Platform::Organization.leave! }
      it { expect { Mumukit::Platform::Organization.current }.to raise_error }
      it { expect { Mumukit::Platform.current_organization_name }.to raise_error }
    end

  end
end
