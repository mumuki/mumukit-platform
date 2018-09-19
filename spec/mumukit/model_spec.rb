require_relative '../spec_helper'

describe Mumukit::Platform::Model do
  class Mancuspia < Mumukit::Platform::Model
    model_attr_accessor :name, :age, :heavy?
  end

  it { expect(Mancuspia.accessors).to eq [:name, :age, :heavy?, :name=, :age=, :heavy=] }
  it { expect(Mancuspia.attributes).to eq [:name, :age, :heavy] }
end
