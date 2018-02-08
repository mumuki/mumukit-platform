require 'active_model'

class Mumukit::Platform::Model
  include ActiveModel::Model

  def empty?
    as_json.empty?
  end

  def self.model_attr_accessor(*keys)
    attr_accessor(*keys)
    define_singleton_method :parse do |hash|
      hash ? new(hash.slice(*keys)) : new
    end
  end

  def self.dump(obj)
    obj.to_json
  end

  def self.load(json)
    json ? new(JSON.parse(json)) : new
  end
end
