class Mumukit::Platform::Organization::Settings < Mumukit::Platform::Model
  model_attr_accessor :login_methods,
                      :raise_hand_enabled?,
                      :feedback_suggestions_enabled?,
                      :public?,
                      :immersive?

  def private?
    !public?
  end

  def login_methods
    @login_methods ||= ['user_pass']
  end
end
