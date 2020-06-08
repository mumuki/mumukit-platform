module Mumukit::Platform::Organization
  extend Mumukit::Platform::Global

  def self.current_locale
    Thread.current[:organization]&.locale || 'en'
  end

  def self.find_by_name!(name)
    Mumukit::Platform.organization_class.find_by_name!(name)
  end

  def self.__global_thread_variable_key__
    :organization
  end

  ## Name validation

  def self.valid_name?(name)
    !!(name =~ anchored_valid_name_regex)
  end

  def self.anchored_valid_name_regex
    /\A#{valid_name_regex}\z/
  end

  def self.valid_name_regex
    /([-a-z0-9_]+(\.[-a-z0-9_]+)*)?/
  end
end

