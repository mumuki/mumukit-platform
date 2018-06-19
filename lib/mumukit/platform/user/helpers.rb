module Mumukit::Platform::User::Helpers
  include Mumukit::Auth::Roles
  include Mumukit::Platform::Notifiable

  ## Implementors must declare the following methods:
  #
  #  * permissions
  #  * uid
  #  * social_id
  #  * image_url
  #  * email
  #  * first_name
  #  * last_name

  ## Permissions

  delegate :has_role?,
           :add_permission!,
           :remove_permission!,
           :has_permission?,
           :has_permission_delegation?,
           :protect!,
           :protect_delegation!,
           :protect_permissions_assignment!,
           to: :permissions

  def platform_class_name
    :User
  end

  def merge_permissions!(new_permissions)
    self.permissions = permissions.merge(new_permissions)
  end

  [:student, :teacher, :headmaster, :janitor].each do |role|
    role_of = "#{role}_of?"
    role_here = "#{role}_here?"

    define_method role_of do |organization|
      has_permission? role, organization.slug
    end

    define_method role_here do
      send role_of, Mumukit::Platform::Organization.current
    end
  end

  def make_student_of!(slug)
    add_permission! :student, slug
  end

  ## Profile

  def full_name
    "#{first_name} #{last_name}"
  end

  alias_method :name, :full_name

  def profile_completed?
    [first_name, last_name].all? &:present?
  end

  def to_s
    "#{full_name} <#{email}> [#{uid}]"
  end

  ## Accesible organizations

  def accessible_organizations
    permissions.accessible_organizations.map do |org|
      Mumukit::Platform::Organization.find_by_name!(org) rescue nil
    end.compact
  end

  def has_accessible_organizations?
    accessible_organizations.present?
  end

  def main_organization
    accessible_organizations.first
  end

  def has_main_organization?
    accessible_organizations.length == 1
  end

  def has_immersive_main_organization?
    !!main_organization.try(&:immersive?)
  end

  ## API Exposure

  def to_param
    uid
  end

  ## Platform JSON

  def self.slice_platform_json(json)
    json.slice(:uid, :social_id, :image_url, :email, :first_name, :last_name, :permissions)
  end

  def as_platform_json
    {
      uid: uid,
      social_id: social_id,
      image_url: image_url,
      email: email,
      first_name: first_name,
      last_name: last_name,
      permissions: permissions
    }.except(*protected_platform_fields).compact
  end

  def protected_platform_fields
    []
  end
end
