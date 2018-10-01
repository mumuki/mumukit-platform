require_relative '../spec_helper'

describe Mumukit::Platform::Application do
  it { expect(Mumukit::Platform.laboratory.organic_url_for 'foo', '/foo/baz').to eq 'http://foo.localmumuki.io/foo/baz' }
  it { expect(Mumukit::Platform.classroom.organic_url_for 'foo', '/foo/baz').to eq 'http://foo.classroom.localmumuki.io/foo/baz' }
  it { expect(Mumukit::Platform.bibliotheca.url).to eq 'http://bibliotheca.localmumuki.io' }
  it { expect(Mumukit::Platform.bibliotheca.domain).to eq 'bibliotheca.localmumuki.io' }

  it { expect(Mumukit::Platform.url_for '/bar').to eq 'http://sample.app.com/bar' }
  it { expect(Mumukit::Platform.organic_url_for 'orga', '/bar').to eq 'http://orga.sample.app.com/bar' }

  describe Mumukit::Platform::Application::Basic do
    context 'with subdomain mapping strategy' do
      let(:mapping) { Mumukit::Platform::OrganizationMapping::Subdomain }
      it { expect(Mumukit::Platform::Application::Organic.new('http://foo.com:3000', mapping).organic_url('bar')).to eq 'http://bar.foo.com:3000' }
    end

    context 'with path mapping strategy' do
      let(:mapping) { Mumukit::Platform::OrganizationMapping::Path }
      it { expect(Mumukit::Platform::Application::Organic.new('http://foo.com:3000', mapping).organic_url('bar')).to eq 'http://foo.com:3000/bar/' }
      it { expect(Mumukit::Platform::Application::Organic.new('http://foo.com:3000/foo', mapping).organic_url('bar')).to eq 'http://foo.com:3000/bar/foo' }
    end
  end
end
