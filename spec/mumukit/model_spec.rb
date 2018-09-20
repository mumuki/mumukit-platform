require_relative '../spec_helper'

describe Mumukit::Platform::Model do
  class Mancuspia < Mumukit::Platform::Model
    model_attr_accessor :name, :age, :heavy?
  end

  it { expect(Mancuspia.accessors).to eq [:name, :age, :heavy?, :name=, :age=, :heavy=] }
  it { expect(Mancuspia.attributes).to eq [:name, :age, :heavy] }

  context 'if model_attr_accessor is used more than once accessors and attributes get extended' do
    class SomeModel < Mumukit::Platform::Model
      model_attr_accessor :name, :heavy?
      model_attr_accessor :age, :big?
    end

    it { expect(SomeModel.accessors).to eq [:name, :heavy?, :age, :big?, :name=, :heavy=, :age=, :big=] }
    it { expect(SomeModel.attributes).to eq [:name, :heavy, :age, :big] }
  end
end
