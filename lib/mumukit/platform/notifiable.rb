module Mumukit::Platform::Notifiable
  def notify_change!
    Mumukit::Nuntius.notify_event! notifiable_change_event_kind, to_event_h
  end

  def notifiable_change_event_kind
    "#{sync_key_kind.as_module_name}Changed"
  end

  def to_event_h
    { sync_key_kind.as_variable_name => to_resource_h }
  end

  def sync_key_kind
    self.class
  end

  required :to_resource_h
end
