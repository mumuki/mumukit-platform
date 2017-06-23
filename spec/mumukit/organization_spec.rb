require_relative '../spec_helper'

describe Mumukit::Platform::Organization do
  let(:organization) do
    struct(
      name: 'orga',
      profile:   Mumukit::Platform::Organization::Profile.new,
      settings:  Mumukit::Platform::Organization::Settings.new,
      theme:     Mumukit::Platform::Organization::Theme.new)
  end

  describe '#current' do
    context 'when switched' do
      before { Mumukit::Platform::Organization.switch! organization }
      it { expect(Mumukit::Platform::Organization.current).to eq organization }
      it { expect(Mumukit::Platform.current_organization_name).to eq 'orga' }
    end
    context 'when not switched' do
      before { Mumukit::Platform::Organization.leave! }
      it { expect { Mumukit::Platform::Organization.current }.to raise_error }
      it { expect { Mumukit::Platform.current_organization_name }.to raise_error }
    end
  end

  describe 'json conversion' do
    let(:json) { {
        name: 'test-orga',
        contact_email: 'issues@mumuki.io',
        books: ['a-book'],
        locale: 'en',
        public: false,
        description: 'Academy',
        login_methods: %w{facebook twitter google},
        logo_url: 'http://mumuki.io/logo-alt-large.png',
        terms_of_service: 'TOS',
        theme_stylesheet_url: 'http://mumuki.io/theme.css',
        extension_javascript_url: 'http://mumuki.io/scripts.js',
        raise_hand_enabled: true,
        id: 998} }

    describe Mumukit::Platform::Organization::Settings do
      describe '.parse' do
        subject { Mumukit::Platform::Organization::Settings.parse(json) }

        it { expect(subject.login_methods).to eq %w{facebook twitter google} }
        it { expect(subject.raise_hand_enabled?).to be true }
        it { expect(subject.public?).to eq false }
      end
      describe '.load' do
        let(:settings) { Mumukit::Platform::Organization::Settings.new(
                            public: true,
                            raise_hand_enabled: false,
                            login_methods: [:google]) }
        let(:dump) { Mumukit::Platform::Organization::Settings.dump(settings) }

        subject { Mumukit::Platform::Organization::Settings.load(dump) }

        it { expect(subject.login_methods).to eq %w{google} }
        it { expect(subject.raise_hand_enabled?).to be false }
        it { expect(subject.public?).to eq true }
      end
    end

    describe Mumukit::Platform::Organization::Theme do
      subject { Mumukit::Platform::Organization::Theme.parse(json) }

      it { expect(subject.theme_stylesheet_url).to eq 'http://mumuki.io/theme.css' }
      it { expect(subject.extension_javascript_url).to eq 'http://mumuki.io/scripts.js' }
    end

    describe Mumukit::Platform::Organization::Profile do
      subject { Mumukit::Platform::Organization::Profile.parse(json) }

      it { expect(subject.logo_url).to eq 'http://mumuki.io/logo-alt-large.png' }
      it { expect(subject.contact_email).to eq 'issues@mumuki.io' }
      it { expect(subject.locale).to eq 'en' }
      it { expect(subject.description).to eq 'Academy' }
      it { expect(subject.terms_of_service).to eq 'TOS' }
    end
  end

  describe Mumukit::Platform::Organization::Helpers do
    before { organization.singleton_class.instance_eval { include Mumukit::Platform::Organization::Helpers } }
    describe 'defaults' do
      it { expect(organization.private?).to be true }
    end
    describe '#url_for' do
      it { expect(organization.url_for 'zaraza').to eq 'http://orga.sample.app.com/zaraza' }
    end
    describe '#domain' do
      it { expect(organization.domain).to eq 'orga.sample.app.com' }
    end
  end
end
