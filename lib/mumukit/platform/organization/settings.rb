class Mumukit::Platform::Organization::Settings < Mumukit::Platform::Model
  model_attr_accessor :login_methods,
                      :login_provider,
                      :login_provider_settings,
                      :raise_hand_enabled?,
                      :feedback_suggestions_enabled?,
                      :public?,
                      :embeddable?,
                      :immersive?,
                      :forum_enabled?,
                      :report_issue_enabled?

  def private?
    !public?
  end

  def login_methods
    @login_methods ||= ['user_pass']
  end
end
