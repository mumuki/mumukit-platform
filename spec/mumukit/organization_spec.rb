require_relative '../spec_helper'

describe Mumukit::Platform::Organization do
  let(:organization) do
    struct(
      name: 'orga',
      profile:   Mumukit::Platform::Organization::Profile.new,
      settings:  Mumukit::Platform::Organization::Settings.new,
      theme:     Mumukit::Platform::Organization::Theme.new)
  end
  let(:json) do
    { name: 'test-orga',
      contact_email: 'issues@mumuki.io',
      books: ['a-book'],
      locale: 'en',
      public: false,
      immersive: false,
      description: 'Academy',
      login_methods: %w{facebook twitter google},
      logo_url: 'http://mumuki.io/logo-alt-large.png',
      terms_of_service: 'TOS',
      theme_stylesheet_url: 'http://mumuki.io/theme.css',
      extension_javascript_url: 'http://mumuki.io/scripts.js',
      raise_hand_enabled: true,
      feedback_suggestions_enabled: true,
      id: 998 }
  end
  let(:images_url_json) do
    { logo_url: 'http://mumuki.io/new-logo.png',
      favicon_url: 'http://mumuki.io/new-favicon.png',
      breadcrumb_image_url: 'http://mumuki.io/new-breadcrumb-image.png',
      open_graph_image_url: 'http://mumuki.io/new-og-image.png' }
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
    describe Mumukit::Platform::Organization::Settings do
      describe '.parse' do
        subject { Mumukit::Platform::Organization::Settings.parse(json) }

        it { expect(subject.login_methods).to eq %w{facebook twitter google} }
        it { expect(subject.raise_hand_enabled?).to be true }
        it { expect(subject.feedback_suggestions_enabled?).to be true }
        it { expect(subject.public?).to eq false }
        it { expect(subject.immersive?).to eq false }
      end
      describe '.load' do
        let(:settings) { Mumukit::Platform::Organization::Settings.new(
                            public: true,
                            immersive: true,
                            raise_hand_enabled: false,
                            login_methods: [:google]) }
        let(:dump) { Mumukit::Platform::Organization::Settings.dump(settings) }

        subject { Mumukit::Platform::Organization::Settings.load(dump) }

        it { expect(subject.login_methods).to eq %w{google} }
        it { expect(subject.raise_hand_enabled?).to be false }
        it { expect(subject.feedback_suggestions_enabled?).to be false }
        it { expect(subject.public?).to eq true }
        it { expect(subject.immersive?).to eq true }
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
      it { expect(subject.description).to eq 'Academy' }
      it { expect(subject.terms_of_service).to eq 'TOS' }

      it { expect(subject.locale).to eq 'en' }
      it { expect(subject.locale_json).to json_eq facebook_code: 'en_US', auth0_code: 'en', name: 'English' }
      it { expect(subject.locale_json).to be_a String }
      it { expect(subject.locale_h).to json_eq facebook_code: 'en_US', auth0_code: 'en', name: 'English' }
      it { expect(subject.locale_h).to be_a Hash }
    end

    describe Mumukit::Platform::Organization::Profile do
      subject { Mumukit::Platform::Organization::Profile.parse({}) }

      it { expect(subject.logo_url).to eq 'https://mumuki.io/logo-alt-large.png' }
      it { expect(subject.banner_url).to eq 'https://mumuki.io/logo-alt-large.png' }
      it { expect(subject.favicon_url).to eq '/favicon.ico' }
      it { expect(subject.breadcrumb_image_url).to eq nil }
      it { expect(subject.open_graph_image_url).to eq 'http://sample.app.com/logo-alt.png' }
    end

    describe Mumukit::Platform::Organization::Profile do
      subject { Mumukit::Platform::Organization::Profile.parse(images_url_json) }
      it { expect(subject.logo_url).to eq 'http://mumuki.io/new-logo.png' }
      it { expect(subject.banner_url).to eq 'http://mumuki.io/new-logo.png' }
      it { expect(subject.favicon_url).to eq 'http://mumuki.io/new-favicon.png' }
      it { expect(subject.breadcrumb_image_url).to eq 'http://mumuki.io/new-breadcrumb-image.png' }
      it { expect(subject.open_graph_image_url).to eq 'http://mumuki.io/new-og-image.png' }
    end
  end

  describe Mumukit::Platform::Organization::Helpers do
    before { organization.singleton_class.instance_eval { include Mumukit::Platform::Organization::Helpers } }
    let(:parsed) { organization.singleton_class.parse(json) }

    describe '.parse' do
      it { expect(parsed[:name]).to eq 'test-orga' }
      it { expect(parsed[:theme]).to be_a Mumukit::Platform::Organization::Theme }
      it { expect(parsed[:settings]).to be_a Mumukit::Platform::Organization::Settings }
      it { expect(parsed[:profile]).to be_a Mumukit::Platform::Organization::Profile }
    end
    describe 'defaults' do
      it { expect(organization.private?).to be true }
      it { expect(organization.logo_url).to eq 'https://mumuki.io/logo-alt-large.png' }
      it { expect(organization.login_methods).to eq ['user_pass'] }
    end
    describe '#url_for' do
      it { expect(organization.url_for 'zaraza').to eq 'http://orga.sample.app.com/zaraza' }
    end
    describe '#domain' do
      it { expect(organization.domain).to eq 'orga.sample.app.com' }
    end

    describe '#valid_name?' do
      def valid_name?(name)
        Mumukit::Platform::Organization::Helpers.valid_name? name
      end

      it { expect(valid_name? 'foo').to be true }
      it { expect(valid_name? 'a.name').to be true }
      it { expect(valid_name? 'a.name.with.subdomains').to be true }
      it { expect(valid_name? '.a.name.that.starts.with.period').to be false }
      it { expect(valid_name? 'a.name.that.ends.with.period.').to be false }
      it { expect(valid_name? 'a.name.that..has.two.periods.in.a.row').to be false }
      it { expect(valid_name? 'a.name.with.Uppercases').to be false }
      it { expect(valid_name? 'A random name').to be false }
    end
  end
end
