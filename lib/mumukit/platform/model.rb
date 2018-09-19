require 'active_model'

class Mumukit::Platform::Model
  include ActiveModel::Model

  def empty?
    as_json.empty?
  end

  ## Accessors

  def self.model_attr_accessor(*readers)
    bools, raws = readers.partition { |it| it.to_s.end_with? '?' }
    raw_bools = bools.map { |it| it.to_s[0..-2].to_sym }
    attributes = raws + raw_bools

    define_attr_readers attributes, raw_bools
    define_attr_writers attributes, raw_bools

    # Parses model from an event.
    # Only allowed attributes are accepted
    define_singleton_method :parse do |hash|
      hash ? new(hash.slice(*attributes)) : new
    end

    define_method :as_json do |options = {}|
      super(options).slice(*attributes.map(&:to_s))
    end

    define_singleton_method(:attributes) do
      attributes
    end

    define_singleton_method(:accessors) do
      readers + attributes.map { |it| "#{it}=".to_sym }
    end
  end

  # Define the attribute readers for the model,
  # given the normal accessor names and the boolean accessor names
  def self.define_attr_readers(readers, bool_readers)
    attr_reader(*readers)
    bool_readers.each { |it| define_method("#{it}?") { !!send(it) } }
  end

  # Define the attribute writers for the model,
  # given the normal accessor names and the boolean accessor names
  def self.define_attr_writers(writers, bool_writers)
    attr_writer(*writers)
    bool_writers.each { |it| define_method("#{it}=") { |value| instance_variable_set("@#{it}", value.to_boolean) } }
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
