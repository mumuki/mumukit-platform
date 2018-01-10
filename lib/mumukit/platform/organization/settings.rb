class Mumukit::Platform::Organization::Settings < Mumukit::Platform::Model
  model_attr_accessor :login_methods,
                      :raise_hand_enabled,
                      :feedback_suggestions_enabled,
                      :laboratory_custom_domain,
                      :classroom_custom_domain,
                      :public

  def raise_hand_enabled?
    !!raise_hand_enabled
  end

  def feedback_suggestions_enabled?
    !!feedback_suggestions_enabled
  end

  def public?
    !!public
  end

  def private?
    !public?
  end

  def login_methods
    @login_methods ||= ['user_pass']
  end
end
