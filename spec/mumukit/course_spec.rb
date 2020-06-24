describe Mumukit::Platform::Course do
  let(:current) { Object.new }

  describe 'current' do
    context 'when not set' do
      before { Mumukit::Platform::Course.leave! }
      it { expect { Mumukit::Platform::Course.current }.to raise_error('course not selected') }
      it { expect(Mumukit::Platform::Course.current?).to be false }
    end

    context 'when set' do
      before { Mumukit::Platform::Course.switch! current }
      it { expect(Mumukit::Platform::Course.current).to eq current }
      it { expect(Mumukit::Platform::Course.current?).to be true }
    end

    context 'when set and reset' do
      before { Mumukit::Platform::Course.switch! current }
      before { Mumukit::Platform::Course.leave! }

      it { expect(Mumukit::Platform::Course.current?).to be false }
    end
  end
end
