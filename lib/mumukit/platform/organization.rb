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
end