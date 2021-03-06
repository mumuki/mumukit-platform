require_relative '../spec_helper'

describe Mumukit::Platform::Application do
  it { expect(Mumukit::Platform.laboratory.organic_url_for 'foo', '/foo/baz').to eq 'http://foo.localmumuki.io/foo/baz' }

  it { expect(Mumukit::Platform.classroom_ui.domain).to eq 'classroom.localmumuki.io' }
  it { expect(Mumukit::Platform.classroom_ui.organic_url_for 'org', '/foo/baz').to eq 'http://org.classroom.localmumuki.io/#/foo/baz' }
  it { expect(Mumukit::Platform.classroom_ui.url).to eq 'http://classroom.localmumuki.io/#/' }

  it { expect(Mumukit::Platform.bibliotheca_ui.domain).to eq 'bibliotheca.localmumuki.io' }
  it { expect(Mumukit::Platform.bibliotheca_ui.url).to eq 'http://bibliotheca.localmumuki.io/#/' }
  it { expect(Mumukit::Platform.bibliotheca_ui.organic_url_for 'org', '/foo/baz').to eq 'http://bibliotheca.localmumuki.io/#/foo/baz' }

  it { expect(Mumukit::Platform.application.url_for '/bar').to eq 'http://sample.app.com/bar' }
  it { expect(Mumukit::Platform.application.organic_url_for 'orga', '/bar').to eq 'http://orga.sample.app.com/bar' }

  describe Mumukit::Platform::Application::Organic do
    context 'with subdomain mapping strategy' do
      let(:mapping) { Mumukit::Platform::OrganizationMapping::Subdomain }
      it { expect(Mumukit::Platform::Application::Organic.new('http://foo.com:3000', mapping).organic_url('bar')).to eq 'http://bar.foo.com:3000' }
    end

    context 'with path mapping strategy' do
      let(:mapping) { Mumukit::Platform::OrganizationMapping::Path }
      it { expect(Mumukit::Platform::Application::Organic.new('http://foo.com:3000', mapping).organic_url('bar')).to eq 'http://foo.com:3000/bar/' }
      it { expect(Mumukit::Platform::Application::Organic.new('http://foo.com:3000/foo', mapping).organic_url('bar')).to eq 'http://foo.com:3000/foo/bar/' }
      it { expect(Mumukit::Platform::Application::Organic.new('http://foo.com:3000/app/', mapping).organic_url_for('an_orga', 'some/long/path')).to eq 'http://foo.com:3000/app/an_orga/some/long/path' }
      it { expect(Mumukit::Platform::Application::Organic.new('http://foo.com:3000/another_app/', mapping).organic_url_for('another_orga', 'some/long/path?with=value')).to eq 'http://foo.com:3000/another_app/another_orga/some/long/path?with=value' }

      context 'with fragments' do
        context 'with prefragment-path' do
          let(:fragmented) { Mumukit::Platform::Application::Organic.new('http://foo.com:3000/classroom/#/', mapping) }

          it { expect(fragmented.url).to eq 'http://foo.com:3000/classroom/#/' }

          it { expect(fragmented.organic_url('org')).to eq 'http://foo.com:3000/classroom/#/org/' }

          it { expect(fragmented.organic_url_for('org', 'path')).to eq 'http://foo.com:3000/classroom/#/org/path' }
          it { expect(fragmented.organic_url_for('org', '/path')).to eq 'http://foo.com:3000/classroom/#/org/path' }
          it { expect(fragmented.organic_url_for('org', 'path/other')).to eq 'http://foo.com:3000/classroom/#/org/path/other' }
        end

        context 'with fragment-path' do
          let(:fragmented) { Mumukit::Platform::Application::Organic.new('http://foo.com:3000/#/classroom/', mapping) }

          it { expect(fragmented.url).to eq 'http://foo.com:3000/#/classroom/' }

          it { expect(fragmented.organic_url('org')).to eq 'http://foo.com:3000/#/classroom/org/' }

          it { expect(fragmented.organic_url_for('org', 'path')).to eq 'http://foo.com:3000/#/classroom/org/path' }
          it { expect(fragmented.organic_url_for('org', '/path')).to eq 'http://foo.com:3000/#/classroom/org/path' }
          it { expect(fragmented.organic_url_for('org', 'path/other')).to eq 'http://foo.com:3000/#/classroom/org/path/other' }
        end

        context 'without fragment-path' do
          let(:fragmented) { Mumukit::Platform::Application::Organic.new('http://foo.com:3000/#', mapping) }

          it { expect(fragmented.url).to eq 'http://foo.com:3000/#' }

          it { expect(fragmented.organic_url('org')).to eq 'http://foo.com:3000/#/org/' }

          it { expect(fragmented.organic_url_for('org', 'path')).to eq 'http://foo.com:3000/#/org/path' }
          it { expect(fragmented.organic_url_for('org', '/path')).to eq 'http://foo.com:3000/#/org/path' }
          it { expect(fragmented.organic_url_for('org', 'path/other')).to eq 'http://foo.com:3000/#/org/path/other' }
        end
      end
    end
  end
end
