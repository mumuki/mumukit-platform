module Mumukit::Platform::WithApplications
  delegate :application, to: :config
  delegate :url_for, :organic_url_for, to: :application

  def laboratory
    Mumukit::Platform::Application::Organic.new config.laboratory_url, organization_mapping
  end

  def classroom
    Mumukit::Platform::Application::Organic.new config.classroom_url, organization_mapping
  end

  def classroom_api
    Mumukit::Platform::Application::Organic.new config.classroom_api_url, organization_mapping
  end

  def office
    Mumukit::Platform::Application::Basic.new config.office_url
  end

  def bibliotheca
    Mumukit::Platform::Application::Basic.new config.bibliotheca_url
  end

  def bibliotheca_api
    Mumukit::Platform::Application::Basic.new config.bibliotheca_api_url
  end

  def application_for(name)
    send name
  end
end