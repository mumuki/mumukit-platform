require 'active_model'

class Mumukit::Platform::Model
  include ActiveModel::Model

  def self.model_attr_accessor(*keys)
    attr_accessor(*keys)
    define_singleton_method :parse do |json|
      new json.slice(*keys)
    end
  end

  def self.dump(obj)
    obj.to_json
  end

  def self.load(json)
    new JSON.parse(json)
  end
end
