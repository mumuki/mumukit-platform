require_relative '../spec_helper'

describe Mumukit::Platform::OrganizationMapping do

  describe '.parse' do
    it { expect(Mumukit::Platform::OrganizationMapping.parse('subdomain')).to eq Mumukit::Platform::OrganizationMapping::Subdomain }
    it { expect(Mumukit::Platform::OrganizationMapping.parse('')).to eq Mumukit::Platform::OrganizationMapping::Path }
    it { expect(Mumukit::Platform::OrganizationMapping.parse('path')).to eq Mumukit::Platform::OrganizationMapping::Path }
    it { expect(Mumukit::Platform::OrganizationMapping.parse('PATH')).to eq Mumukit::Platform::OrganizationMapping::Path }
    it { expect { Mumukit::Platform::OrganizationMapping.parse('foo') }.to raise_error }
  end

  context 'with test defaults - http://`subdomain`.sample.app.com' do
    let(:request) { new_rack_request 'http', 'foo.sample.app.com' }

    it { expect(Mumukit::Platform::OrganizationMapping.from_env).to eq Mumukit::Platform::OrganizationMapping::Subdomain }
    it { expect(Mumukit::Platform.organization_name(request)).to eq 'foo' }
    it { expect(Mumukit::Platform.implicit_organization?(request)).to be false }
  end

  describe Mumukit::Platform::OrganizationMapping::Subdomain do
    subject { Mumukit::Platform::OrganizationMapping::Subdomain }

    describe '#path_under_namespace?' do
      it { expect(subject.path_under_namespace? 'central', '/central/foo/bar', 'foo').to be false }
      it { expect(subject.path_under_namespace? 'central', '/central/foo/bar', 'central').to be true }
    end

    context 'on non central' do
      let(:request) { new_rack_request 'http', 'foo.something.com' }
      it { expect(subject.organization_name(request, 'something.com')).to eq 'foo' }
    end

    context 'on explicit central' do
      let(:request) { new_rack_request 'http', 'central.something.com' }
      it { expect(subject.organization_name(request, 'something.com')).to eq 'central' }
      it { expect(subject.implicit_organization?(request, 'something.com')).to be false }
    end

    context 'on implicit central' do
      let(:request) { new_rack_request 'http', 'something.com' }
      it { expect(subject.organization_name(request, 'something.com')).to eq 'central' }
      it { expect(subject.implicit_organization?(request, 'something.com')).to be true }
    end
  end

  describe Mumukit::Platform::OrganizationMapping::Path do
    subject { Mumukit::Platform::OrganizationMapping::Path }

    describe '#path_under_namespace?' do
      it { expect(subject.path_under_namespace? 'central', '/central/foo/bar', 'foo').to be true }
      it { expect(subject.path_under_namespace? 'central', '/central/foo/bar', 'central').to be false }
      it { expect(subject.path_under_namespace? 'central', '/central/foo/bar', 'bar').to be false }
      it { expect(subject.path_under_namespace? 'central', '/central/foo/bar', 'baz').to be false }
    end

    context 'on non central' do
      let(:request) { new_rack_request 'http', 'something.com', '80', '/foo' }
      it { expect(subject.organization_name(request, 'something.com')).to eq 'foo' }
    end

    context 'on non central with extra path' do
      let(:request) { new_rack_request 'http', 'something.com', '80', '/foo/bar' }
      it { expect(subject.organization_name(request, 'something.com')).to eq 'foo' }
    end

    context 'on non central with trailing slash' do
      let(:request) { new_rack_request 'http', 'something.com', '80', '/foo/' }
      it { expect(subject.organization_name(request, 'something.com')).to eq 'foo' }
    end

    context 'on central' do
      let(:request) { new_rack_request 'http', 'something.com', '80', '/central/' }
      it { expect(subject.organization_name(request, 'something.com')).to eq 'central' }
    end
  end
end
