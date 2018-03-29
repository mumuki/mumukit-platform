module Mumukit::Platform::Notifiable
  def notify!(event_type = :changed)
    Mumukit::Nuntius.notify_event! platform_event_name(event_type), as_platform_event
  end

  def platform_event_name(event_type)
    "#{platform_class_name}#{event_type.to_s.titlecase}"
  end

  def as_platform_event
    { platform_class_name.downcase => as_platform_json }
  end
end
