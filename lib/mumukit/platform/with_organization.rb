module Mumukit::Platform::WithOrganization
  def current_organization
    Mumukit::Platform::Organization.current
  end

  def current_organization_name
    current_organization.name
  end
end