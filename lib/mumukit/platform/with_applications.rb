module Mumukit::Platform::WithApplications
  delegate :application, to: :config

  def laboratory
    Mumukit::Platform::Application::Organic.new config.laboratory_url
  end

  def classroom_ui
    Mumukit::Platform::Application::Organic.new config.classroom_ui_url
  end

  def classroom_api
    Mumukit::Platform::Application::Organic.new config.classroom_api_url
  end

  def bibliotheca_ui
    Mumukit::Platform::Application::Basic.new config.bibliotheca_ui_url
  end

  def bibliotheca_api
    Mumukit::Platform::Application::Basic.new config.bibliotheca_api_url
  end

  def application_for(name)
    send name
  end
end
