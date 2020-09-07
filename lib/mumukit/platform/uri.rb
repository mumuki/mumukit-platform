class URI::HTTP
  def subdominate(subdomain)
    if host.start_with? 'www.'
      new_host = host.gsub('www.', "www.#{subdomain}.")
    else
      new_host = "#{subdomain}.#{host}"
    end
    rebuild(host: new_host)
  end

  def tenantize(route)
    if path.end_with? '/'
      new_path = "#{path}#{route}/"
    else
      new_path = "#{path}/#{route}/"
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
