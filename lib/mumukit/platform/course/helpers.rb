module Mumukit::Platform::Course::Helpers
  ## Implementors must declare the following methods:
  #
  #  * slug
  #  * shifts
  #  * code
  #  * days
  #  * period
  #  * description

  ## API Exposure

  def to_param
    slug
  end

  ## Resource Hash

  def self.slice_resource_h(resource_h)
    resource_h.slice(:slug, :shifts, :code, :days, :period, :description)
  end

  def to_resource_h
    {
      slug: slug,
      shifts: shifts,
      code: code,
      days: days,
      period: period,
      description: description
    }.except(*protected_resource_fields).compact
  end

  def protected_resource_fields
    []
  end
end
