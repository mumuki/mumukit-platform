require 'spec_helper'

def add_extra_subdomain(original_url, **options)
  URI(original_url).subdominate('extra', **options).to_s
end

def add_extra_path(original_url, **options)
  URI(original_url).tenantize('extra', **options).to_s
end

describe URI do
  describe '#subdominate' do
    it { expect(add_extra_subdomain('https://foo.bar')).to eq 'https://extra.foo.bar' }
    it { expect(add_extra_subdomain('http://foo.bar')).to eq 'http://extra.foo.bar' }
    it { expect(add_extra_subdomain('http://foo.bar/foo')).to eq 'http://extra.foo.bar/foo' }

    it { expect(add_extra_subdomain('http://foo.bar/#')).to eq 'http://extra.foo.bar/#' }
    it { expect(add_extra_subdomain('http://foo.bar/#', fragmented: true)).to eq 'http://extra.foo.bar/#/' }
    it { expect(add_extra_subdomain('http://foo.bar/#/', fragmented: true)).to eq 'http://extra.foo.bar/#/' }

    it { expect(add_extra_subdomain('http://foo.bar/#foo')).to eq 'http://extra.foo.bar/#foo' }
    it { expect(add_extra_subdomain('http://foo.bar/#/foo')).to eq 'http://extra.foo.bar/#/foo' }
    it { expect(add_extra_subdomain('http://foo.bar/#foo', fragmented: true)).to eq 'http://extra.foo.bar/#foo/' }
    it { expect(add_extra_subdomain('http://foo.bar/#/foo', fragmented: true)).to eq 'http://extra.foo.bar/#/foo/' }

    it { expect(add_extra_subdomain('http://www.foo.bar.com/')).to eq 'http://www.extra.foo.bar.com/' }
    it { expect(add_extra_subdomain('http://foo.bar.com/foo?z=3')).to eq 'http://extra.foo.bar.com/foo?z=3' }
    it { expect(add_extra_subdomain('http://foo.bar.com:3000/foo?z=3')).to eq 'http://extra.foo.bar.com:3000/foo?z=3' }
  end
  describe '#tenantize' do
    it { expect(add_extra_path('https://foo.bar')).to eq 'https://foo.bar/extra/' }
    it { expect(add_extra_path('http://foo.bar')).to eq 'http://foo.bar/extra/' }
    it { expect(add_extra_path('http://foo.bar/foo')).to eq 'http://foo.bar/foo/extra/' }

    it { expect(add_extra_path('http://foo.bar/#')).to eq 'http://foo.bar/extra/#' }
    it { expect(add_extra_path('http://foo.bar/#', fragmented: true)).to eq 'http://foo.bar/#/extra/' }
    it { expect(add_extra_path('http://foo.bar/#/', fragmented: true)).to eq 'http://foo.bar/#/extra/' }

    it { expect(add_extra_path('http://foo.bar/#foo')).to eq 'http://foo.bar/extra/#foo' }
    it { expect(add_extra_path('http://foo.bar/#/foo')).to eq 'http://foo.bar/extra/#/foo' }
    it { expect(add_extra_path('http://foo.bar/#foo', fragmented: true)).to eq 'http://foo.bar/#foo/extra/' }
    it { expect(add_extra_path('http://foo.bar/#/foo', fragmented: true)).to eq 'http://foo.bar/#/foo/extra/' }

    it { expect(add_extra_path('http://foo.bar.com/')).to eq 'http://foo.bar.com/extra/' }
    it { expect(add_extra_path('http://foo.bar.com/foo')).to eq 'http://foo.bar.com/foo/extra/' }
    it { expect(add_extra_path('http://foo.bar.com/foo?z=3')).to eq 'http://foo.bar.com/foo/extra/?z=3' }
    it { expect(add_extra_path('http://foo.bar.com:3000/foo?z=3')).to eq 'http://foo.bar.com:3000/foo/extra/?z=3' }
  end
end
