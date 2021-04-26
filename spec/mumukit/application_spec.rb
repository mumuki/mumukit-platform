require_relative '../spec_helper'

describe Mumukit::Platform::Application do
  it { expect(Mumukit::Platform.laboratory.organic_url_for 'foo', '/foo/baz').to eq 'http://foo.localmumuki.io/foo/baz' }
  it { expect(Mumukit::Platform.laboratory.retenantize_in 'an-orga', '/a_path').to eq 'http://an-orga.localmumuki.io/a_path' }

  it { expect(Mumukit::Platform.classroom_ui.domain).to eq 'classroom.localmumuki.io' }
  it { expect(Mumukit::Platform.classroom_ui.organic_url_for 'org', '/foo/baz').to eq 'http://org.classroom.localmumuki.io/#/foo/baz' }
  it { expect(Mumukit::Platform.classroom_ui.url).to eq 'http://classroom.localmumuki.io/#/' }

  it { expect(Mumukit::Platform.bibliotheca_ui.domain).to eq 'bibliotheca.localmumuki.io' }
  it { expect(Mumukit::Platform.bibliotheca_ui.url).to eq 'http://bibliotheca.localmumuki.io/#/' }
  it { expect(Mumukit::Platform.bibliotheca_ui.organic_url_for 'org', '/foo/baz').to eq 'http://bibliotheca.localmumuki.io/#/foo/baz' }

  it { expect(Mumukit::Platform.application.url_for '/bar').to eq 'http://sample.app.com/bar' }
  it { expect(Mumukit::Platform.application.organic_url_for 'org', '/bar').to eq 'http://org.sample.app.com/bar' }

  describe Mumukit::Platform::Application::Basic do
    context 'with subdomain mapping strategy' do
      let(:mapping) { Mumukit::Platform::OrganizationMapping::Subdomain }
      it { expect(new_basic_app('http://foo.com:3000').organic_url('org')).to eq 'http://foo.com:3000' }
      it { expect(new_basic_app('http://foo.com:3000').retenantize_in('other-orga', '/an-orga/deep')).to eq 'http://foo.com:3000/an-orga/deep' }
    end

    context 'with path mapping strategy' do
      let(:mapping) { Mumukit::Platform::OrganizationMapping::Path }
      it { expect(new_basic_app('http://foo.com:3000').organic_url('org')).to eq 'http://foo.com:3000' }
      it { expect(new_basic_app('http://foo.com:3000/foo').organic_url('org')).to eq 'http://foo.com:3000/foo' }
      it { expect(new_basic_app('http://foo.com:3000/app/').organic_url_for('an_org', 'some/long/path')).to eq 'http://foo.com:3000/app/some/long/path' }
      it { expect(new_basic_app('http://foo.com:3000/another_app/').organic_url_for('another_org', 'some/long/path?with=value')).to eq 'http://foo.com:3000/another_app/some/long/path?with=value' }
      it { expect(new_basic_app('http://foo.com:3000').retenantize_in('other-orga', '/an-orga/deep')).to eq 'http://foo.com:3000/an-orga/deep' }

      context 'with fragments' do
        context 'with prefragment-path' do
          let(:fragmented) { new_basic_app('http://foo.com:3000/bibliotheca/#/') }

          it { expect(fragmented.url).to eq 'http://foo.com:3000/bibliotheca/#/' }

          it { expect(fragmented.organic_url('org')).to eq 'http://foo.com:3000/bibliotheca/#/' }

          it { expect(fragmented.organic_url_for('org', 'path')).to eq 'http://foo.com:3000/bibliotheca/#/path' }
          it { expect(fragmented.organic_url_for('org', '/path')).to eq 'http://foo.com:3000/bibliotheca/#/path' }
          it { expect(fragmented.organic_url_for('org', 'path/other')).to eq 'http://foo.com:3000/bibliotheca/#/path/other' }
        end

        context 'with fragment-path' do
          let(:fragmented) { new_basic_app('http://foo.com:3000/#/bibliotheca/') }

          it { expect(fragmented.url).to eq 'http://foo.com:3000/#/bibliotheca/' }

          it { expect(fragmented.organic_url('org')).to eq 'http://foo.com:3000/#/bibliotheca/' }

          it { expect(fragmented.organic_url_for('org', 'path')).to eq 'http://foo.com:3000/#/bibliotheca/path' }
          it { expect(fragmented.organic_url_for('org', '/path')).to eq 'http://foo.com:3000/#/bibliotheca/path' }
          it { expect(fragmented.organic_url_for('org', 'path/other')).to eq 'http://foo.com:3000/#/bibliotheca/path/other' }
        end

        context 'without fragment-path' do
          let(:fragmented) { new_basic_app('http://foo.com:3000/#') }

          it { expect(fragmented.url).to eq 'http://foo.com:3000/#' }

          it { expect(fragmented.organic_url('org')).to eq 'http://foo.com:3000/#' }

          it { expect(fragmented.organic_url_for('org', 'path')).to eq 'http://foo.com:3000/#/path' }
          it { expect(fragmented.organic_url_for('org', '/path')).to eq 'http://foo.com:3000/#/path' }
          it { expect(fragmented.organic_url_for('org', 'path/other')).to eq 'http://foo.com:3000/#/path/other' }
        end
      end
    end
  end


  describe Mumukit::Platform::Application::Organic do
    context 'with subdomain mapping strategy' do
      let(:mapping) { Mumukit::Platform::OrganizationMapping::Subdomain }
      it { expect(new_organic_app('http://foo.com:3000', mapping).organic_url('bar')).to eq 'http://bar.foo.com:3000' }
      it { expect(new_organic_app('http://foo.com:3000', mapping).retenantize_in('bar', '/a_path/deep')).to eq 'http://bar.foo.com:3000/a_path/deep' }
    end

    context 'with path mapping strategy' do
      let(:mapping) { Mumukit::Platform::OrganizationMapping::Path }
      it { expect(new_organic_app('http://foo.com:3000', mapping).organic_url('org')).to eq 'http://foo.com:3000/org/' }
      it { expect(new_organic_app('http://foo.com:3000/foo', mapping).organic_url('org')).to eq 'http://foo.com:3000/foo/org/' }
      it { expect(new_organic_app('http://foo.com:3000/app/', mapping).organic_url_for('an_org', 'some/long/path')).to eq 'http://foo.com:3000/app/an_org/some/long/path' }
      it { expect(new_organic_app('http://foo.com:3000/another_app/', mapping).organic_url_for('another_org', 'some/long/path?with=value')).to eq 'http://foo.com:3000/another_app/another_org/some/long/path?with=value' }
      it { expect(new_organic_app('http://foo.com:3000', mapping).retenantize_in('other_orga', '/an_orga/deep')).to eq 'http://foo.com:3000/other_orga/deep' }

      context 'with fragments' do
        context 'with prefragment-path' do
          let(:fragmented) { new_organic_app('http://foo.com:3000/classroom/#/', mapping) }

          it { expect(fragmented.url).to eq 'http://foo.com:3000/classroom/#/' }

          it { expect(fragmented.organic_url('org')).to eq 'http://foo.com:3000/classroom/#/org/' }

          it { expect(fragmented.organic_url_for('org', 'path')).to eq 'http://foo.com:3000/classroom/#/org/path' }
          it { expect(fragmented.organic_url_for('org', '/path')).to eq 'http://foo.com:3000/classroom/#/org/path' }
          it { expect(fragmented.organic_url_for('org', 'path/other')).to eq 'http://foo.com:3000/classroom/#/org/path/other' }
        end

        context 'with fragment-path' do
          let(:fragmented) { new_organic_app('http://foo.com:3000/#/classroom/', mapping) }

          it { expect(fragmented.url).to eq 'http://foo.com:3000/#/classroom/' }

          it { expect(fragmented.organic_url('org')).to eq 'http://foo.com:3000/#/classroom/org/' }

          it { expect(fragmented.organic_url_for('org', 'path')).to eq 'http://foo.com:3000/#/classroom/org/path' }
          it { expect(fragmented.organic_url_for('org', '/path')).to eq 'http://foo.com:3000/#/classroom/org/path' }
          it { expect(fragmented.organic_url_for('org', 'path/other')).to eq 'http://foo.com:3000/#/classroom/org/path/other' }
        end

        context 'without fragment-path' do
          let(:fragmented) { new_organic_app('http://foo.com:3000/#', mapping) }

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

%w(basic organic).each do |app_type|
  define_method("new_#{app_type}_app") do |*params|
    "Mumukit::Platform::Application::#{app_type.capitalize}".constantize.new *params
  end
end
