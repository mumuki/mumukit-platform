describe Mumukit::Platform::Organization do
  let(:current) { Object.new }

  describe '#valid_name?' do
    def valid_name?(name)
      Mumukit::Platform::Organization::valid_name? name
    end

    it { expect(valid_name? 'foo').to be true }
    it { expect(valid_name? 'a.name').to be true }
    it { expect(valid_name? 'a.name.with.subdomains').to be true }
    it { expect(valid_name? '.a.name.that.starts.with.period').to be false }
    it { expect(valid_name? 'a.name.that.ends.with.period.').to be false }
    it { expect(valid_name? 'a.name.that..has.two.periods.in.a.row').to be false }
    it { expect(valid_name? 'a.name.with.Uppercases').to be false }
    it { expect(valid_name? 'A random name').to be false }
  end

  describe 'current' do
    context 'when not set' do
      before { Mumukit::Platform::Organization.leave! }
      it { expect { Mumukit::Platform::Organization.current }.to raise_error('organization not selected') }
      it { expect(Mumukit::Platform::Organization.current?).to be false }
    end

    context 'when set' do
      before { Mumukit::Platform::Organization.switch! current }
      it { expect(Mumukit::Platform::Organization.current).to eq current }
      it { expect(Mumukit::Platform::Organization.current?).to be true }
    end

    context 'when set and reset' do
      before { Mumukit::Platform::Organization.switch! current }
      before { Mumukit::Platform::Organization.leave! }

      it { expect(Mumukit::Platform::Organization.current?).to be false }
    end
  end
end
