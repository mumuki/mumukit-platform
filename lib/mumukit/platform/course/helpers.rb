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

  ## Platform JSON

  def as_platform_json
    {
      slug: slug,
      shifts: shifts,
      code: code,
      days: days,
      period: period,
      description: description
    }.except(*protected_platform_fields).compact
  end

  def protected_platform_fields
    []
  end
end
