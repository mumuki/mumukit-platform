class URI::HTTP
  def subdominate(subdomain, **options)
    if host.start_with? 'www.'
      new_host = host.gsub('www.', "www.#{subdomain}.")
    else
      new_host = "#{subdomain}.#{host}"
    end
    rebuild({host: new_host}, **options)
  end

  def tenantize(route, fragmented: false)
    if fragmented && fragment
      new_path = route
    else
      new_path = "#{path.chomp('/')}/#{route}/"
    end
    rebuild({path: new_path}, fragmented: fragmented)
  end

  def rebuild(updates, fragmented: false)
    if fragmented && fragment
      fragment = "#{self.fragment}/#{updates[:path]}/".squeeze('/')
      updates = updates.except(:path)
    else
      fragment = self.fragment
    end

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