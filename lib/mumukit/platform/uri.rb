class URI::HTTP
  def subdominate(subdomain)
    if host.start_with? 'www.'
      new_host = host.gsub('www.', "www.#{subdomain}.")
    else
      new_host = "#{subdomain}.#{host}"
    end
    self.class.build(scheme: scheme,
                    host: new_host,
                    path: path,
                    query: query,
                    port: port)
  end

  def subroute(route)
    if path.start_with? '/'
      new_path = "/#{route}#{path}"
    else
      new_path = "/#{route}/#{path}"
    end
    self.class.build(scheme: scheme,
                    host: host,
                    path: new_path,
                    query: query,
                    port: port)
  end

  def url_for(path)
    URI.join(self, path).to_s
  end
end