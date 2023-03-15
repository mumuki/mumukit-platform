require_relative '../spec_helper'

describe Mumukit::Platform::PathMapping do

  context 'with test defaults - http://`subdomain`.sample.app.com' do
    let(:request) { new_rack_request 'http', 'foo.sample.app.com' }

    it { expect(Mumukit::Platform.organization_name(request)).to be_nil }
    it { expect(Mumukit::Platform.implicit_organization?(request)).to be false }
  end

  describe Mumukit::Platform::PathMapping do
    subject { Mumukit::Platform::PathMapping }

    describe '#path_under_namespace?' do
      it { expect(subject.path_under_namespace? 'central', '/central/foo/bar', 'foo').to be true }
      it { expect(subject.path_under_namespace? 'central', '/central/foo/bar', 'central').to be false }
      it { expect(subject.path_under_namespace? 'central', '/central/foo/bar', 'bar').to be false }
      it { expect(subject.path_under_namespace? 'central', '/central/foo/bar', 'baz').to be false }
    end

    context 'on non central' do
      let(:request) { new_rack_request 'http', 'something.com', '80', '/foo' }
      it { expect(subject.organization_name(request, 'something.com')).to eq 'foo' }
      it { expect(subject.inorganic_path_for(request)).to eq '' }
    end

    context 'on non central with extra path' do
      let(:request) { new_rack_request 'http', 'something.com', '80', '/foo/bar' }
      it { expect(subject.organization_name(request, 'something.com')).to eq 'foo' }
      it { expect(subject.inorganic_path_for(request)).to eq 'bar' }
    end

    context 'on non central with extra path and params' do
      let(:request) { new_rack_request 'http', 'something.com', '80', '/foo/bar/other?param=val' }
      it { expect(subject.organization_name(request, 'something.com')).to eq 'foo' }
      it { expect(subject.inorganic_path_for(request)).to eq 'bar/other?param=val' }
    end

    context 'on non central with trailing slash' do
      let(:request) { new_rack_request 'http', 'something.com', '80', '/foo/' }
      it { expect(subject.inorganic_path_for(request)).to eq '' }
    end

    context 'on central' do
      let(:request) { new_rack_request 'http', 'something.com', '80', '/central/' }
      it { expect(subject.organization_name(request, 'something.com')).to eq 'central' }
      it { expect(subject.inorganic_path_for(request)).to eq '' }
    end
  end
end
