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
    uri = organic_uri(organization)
    # warning: this code is tightly
    # coupled to the fact that applications can only rebuild urls
    # in fragmented-mode
    if uri.fragment
      uri.to_s.chomp('/') + '/' + relative_path(path)
    else
      uri.url_for(relative_path path)
    end
  end

  def relative_path(path)
    path.start_with?('/') ? path[1..-1] : path
  end

  class Basic < Mumukit::Platform::Application
    def organic_uri(_organization)
      uri
    end
  end

  class Organic < Mumukit::Platform::Application
    def initialize(url)
      super(url)
    end

    def organic_uri(organization)
      Mumukit::Platform::PathMapping.organic_uri(uri, organization)
    end
  end
end
