module Mumukit::Platform
  def self.bibliotheca_bridge
    Mumukit::Bridge::Bibliotheca.new(config.bibliotheca_api_url)
  end

  def self.thesaurus_bridge
    Mumukit::Bridge::Thesaurus.new(config.thesaurus_url)
  end
end
