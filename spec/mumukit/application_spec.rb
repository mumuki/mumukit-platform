require_relative '../spec_helper'

describe Mumukit::Platform::Application do
  it { expect(Mumukit::Platform.laboratory.organic_url_for 'foo', '/foo/baz').to eq 'http://foo.localmumuki.io/foo/baz' }
  it { expect(Mumukit::Platform.classroom.organic_url_for 'foo', '/foo/baz').to eq 'http://foo.classroom.localmumuki.io/foo/baz' }
  it { expect(Mumukit::Platform.office.url).to eq 'http://office.localmumuki.io' }
  it { expect(Mumukit::Platform.office.domain).to eq 'office.localmumuki.io' }

  it { expect(Mumukit::Platform.url_for '/bar').to eq 'http://sample.app.com/bar' }
  it { expect(Mumukit::Platform.organic_url_for 'orga', '/bar').to eq 'http://orga.sample.app.com/bar' }

  it { expect(Mumukit::Platform::Application::Organic.new('http://foo.com:3000').organic_url('bar')).to eq 'http://bar.foo.com:3000' }
end
