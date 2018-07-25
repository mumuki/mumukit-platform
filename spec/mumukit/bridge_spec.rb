require_relative '../spec_helper'

describe Mumukit::Platform do

  it { expect(Mumukit::Platform.thesaurus_bridge).to be_a Mumukit::Bridge::Thesaurus }
  it { expect(Mumukit::Platform.thesaurus_bridge.url).to eq 'http://thesaurus.localmumuki.io' }

  it { expect(Mumukit::Platform.bibliotheca_bridge).to be_a Mumukit::Bridge::Bibliotheca }
  it { expect(Mumukit::Platform.bibliotheca_bridge.url).to eq 'http://bibliotheca-api.localmumuki.io' }

  describe 'import_contents!' do
    let(:imported_resources) { [] }
    let(:bridge) { Mumukit::Bridge::Bibliotheca.new('http://nonexistenurl.com') }
    let(:append_resources) { proc { |resource_type, slug| imported_resources << [resource_type, slug] } }

    before do
      expect(bridge).to receive(:get_collection).and_return(
        [{'slug' => 'foo/a-guide'}, {'slug' => 'baz/a-guide'}],
        [{'slug' => 'foo/a-topic'}, {'slug' => 'baz/a-topic'}],
        [])
    end

    context 'all match' do
      before { bridge.import_contents!(&append_resources) }
      it do
        expect(imported_resources).to eq [
          ['guide', 'foo/a-guide'],
          ['guide', 'baz/a-guide'],
          ['topic', 'foo/a-topic'],
          ['topic', 'baz/a-topic'],
        ]
      end
    end

    context 'some match' do
      before { bridge.import_contents!(/^foo.*$/, &append_resources) }
      it { expect(imported_resources).to eq [['guide', 'foo/a-guide'], ['topic', 'foo/a-topic']] }
    end
  end
end
