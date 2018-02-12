require 'active_model'

class Mumukit::Platform::Model
  include ActiveModel::Model

  def empty?
    as_json.empty?
  end

  def self.model_attr_accessor(*keys)
    attr_accessor(*keys)

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
