require_relative '../spec_helper'

describe Mumukit::Platform do

  it { expect(Mumukit::Platform.thesaurus_bridge).to be_a Mumukit::Bridge::Thesaurus }
  it { expect(Mumukit::Platform.thesaurus_bridge.url).to eq 'http://thesaurus.localmumuki.io' }

  it { expect(Mumukit::Platform.bibliotheca_bridge).to be_a Mumukit::Bridge::Bibliotheca }
  it { expect(Mumukit::Platform.bibliotheca_bridge.url).to eq 'http://bibliotheca-api.localmumuki.io' }
end
