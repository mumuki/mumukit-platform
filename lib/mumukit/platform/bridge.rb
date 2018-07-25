module Mumukit::Platform
  def self.bibliotheca_bridge
    Mumukit::Bridge::Bibliotheca.new(config.bibliotheca_api_url)
  end

  def self.thesaurus_bridge
    Mumukit::Bridge::Thesaurus.new(config.thesaurus_url)
  end
end

class Mumukit::Bridge::Thesaurus

  # Import all the languages the runners suppor,
  # using a block that will do the actual
  # persistence job.
  #
  # The block takes the language's runner's url (string).
  #
  # Exceptions raised within the block will be ignored
  def import_languages!(&block)
    runners.each do |url|
      puts "Importing Language #{url}"
      begin
        block.call url
      rescue => e
        puts "Ignoring Language #{url} because of import error #{e}"
      end
    end
  end
end

class Mumukit::Bridge::Bibliotheca

  # Import all the contents whose slug matches the given regex, using a block that will do the actual
  # persistence job.
  #
  # The block takes:
  #
  #  * a resource_type (string): guide | topic | book
  #  * a slug (string)
  #
  # Exceptions raised within the block will be ignored
  def import_contents!(slug_regex = /.*/, &block)
    %w(guide topic book).each do |resource_type|
      import_content!(resource_type, slug_regex) { |slug| block.call(resource_type, slug)  }
    end
  end

  # Import all the contents of a given type, that matches a given slug
  def import_content!(resource_type, slug_regex = /.*/, &block)
    send(resource_type.to_s.pluralize).each do |resource|
      slug = resource['slug']
      return unless slug_regex.matches? slug

      puts "Importing #{resource_type} #{slug}"
      begin
        block.call slug
      rescue => e
        puts "Ignoring #{slug} because of import error #{e}"
      end
    end
  end
end
