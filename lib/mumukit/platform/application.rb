class Mumukit::Platform::Application
  attr_accessor :url

  def initialize(url)
    @url = url
  end

  def uri
    URI(@url)
  end

  required :organic_uri

  def organic_url(organization)
    organic_uri(organization).to_s
  end

  def organic_domain(organization)
    organic_uri(organization).host
  end

  def domain
    uri.host
  end

  def url_for(path)
    uri.url_for(path) if path
  end

  def organic_url_for(organization, path)
    organic_uri(organization).url_for(path)
  end

  class Basic < Mumukit::Platform::Application
    def organic_uri(_organization)
      uri
    end
  end

  class Organic < Mumukit::Platform::Application
    def initialize(url, organization_mapping)
      super(url)
      @organization_mapping = organization_mapping
    end

    def organic_uri(organization)
      @organization_mapping.organic_uri(uri, organization)
    end
  end
end