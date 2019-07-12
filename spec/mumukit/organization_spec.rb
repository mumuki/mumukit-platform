describe Mumukit::Platform::Organization do
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
end