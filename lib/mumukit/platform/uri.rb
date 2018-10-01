class URI::HTTP
  def subdominate(subdomain)
    if host.start_with? 'www.'
      new_host = host.gsub('www.', "www.#{subdomain}.")
    else
      new_host = "#{subdomain}.#{host}"
    end
    rebuild(host: new_host)
  end

  def subroute(route)
    if path.start_with? '/'
      new_path = "/#{route}#{path}"
    else
      new_path = "/#{route}/#{path}"
    end
    rebuild(path: new_path)
  end

  def rebuild(updates)
    self.class.build({
      scheme: scheme,
      host: host,
      path: path,
      query: query,
      port: port,
      fragment: fragment}.merge(updates))
  end

  def url_for(path)
    URI.join(self, path).to_s
  end
end
