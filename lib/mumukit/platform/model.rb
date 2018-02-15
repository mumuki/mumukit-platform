require 'active_model'

class Mumukit::Platform::Model
  include ActiveModel::Model

  def empty?
    as_json.empty?
  end

  def self.model_attr_accessor(*keys)
    bools, raws = keys.partition { |it| it.to_s.end_with? '?' }
    raw_bools = bools.map { |it| it.to_s[0..-2].to_sym }
    keys = raws + raw_bools

    attr_accessor(*keys)

    raw_bools.each do |it|
      define_method("#{it}?") { !!send(it) }
      define_method("#{it}=") { |value| instance_variable_set("@#{it}", value.to_boolean) }
    end

    # Parses model from an event.
    # Only allowed keys are accepted
    define_singleton_method :parse do |hash|
      hash ? new(hash.slice(*keys)) : new
    end
  end

  ## Serialization

  # Serializes model
  def self.dump(obj)
    obj.to_json
  end

  # Deserializes model
  def self.load(json)
    json ? new(JSON.parse(json)) : new
  end
end


class Object
  def to_boolean
    [true, 'true', '1', 1].include?(self)
  end
end
