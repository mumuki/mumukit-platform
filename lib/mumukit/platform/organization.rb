module Mumukit::Platform::Organization
  def self.switch!(organization)
    raise 'Organization must not be nil' unless organization
    Thread.current[:organization] = organization
  end

  def self.leave!
    Thread.current[:organization] = nil
  end

  def self.current
    Thread.current[:organization] || raise('organization not selected')
  end

  def self.current?
    !!Thread.current[:organization]
  end

  def self.current_locale
    Thread.current[:organization]&.locale || 'en'
  end

  def self.find_by_name!(name)
    Mumukit::Platform.organization_class.find_by_name!(name)
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

