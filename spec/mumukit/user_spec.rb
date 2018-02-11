require_relative '../spec_helper'

class DemoUser
  include Mumukit::Platform::User::Helpers

  attr_accessor :permissions

  def initialize
    @permissions = Mumukit::Auth::Permissions.new
  end
end

describe Mumukit::Platform::User do
  describe 'user_class' do
    before { Mumukit::Platform.config.user_class = nil }

    context 'when no user_class set' do
      it { expect { Mumukit::Platform.user_class }.to raise_error 'You must configure your user class first' }
    end

    context 'when user_class set' do
      before { Mumukit::Platform.config.user_class = DemoUser }

      it { expect(Mumukit::Platform.user_class).to eq DemoUser }
    end

    context 'when user_class_name set' do
      before { Mumukit::Platform.config.user_class_name = 'DemoUser' }

      it { expect(Mumukit::Platform.user_class).to eq DemoUser }
    end
  end

  describe Mumukit::Platform::User::Helpers do
    let(:user) { DemoUser.new }
    let(:organization) { struct slug: 'foo/_' }

    it { expect(user.writer?).to be false }
    it { expect(user.student?).to be false }

    describe 'make_student_of!' do
      before { user.make_student_of! organization }

      it { expect(user.student?).to be true }
      it { expect(user.student? 'bar/_').to be false }

      it { expect(user.student_of? organization).to be true }
      it { expect(user.student_of? struct(slug: 'bar/_')).to be false }
    end

    describe 'accessible_organizations' do
      before { Mumukit::Platform.config.organization_class = class_double('DemoOrganization') }

      context 'no organization' do
        it { expect(user.accessible_organizations).to eq [] }
        it { expect(user.has_accessible_organizations?).to be false }
        it { expect(user.has_main_organization?).to be false }
        it { expect(user.has_immersive_main_organization?).to be false }
      end

      context 'with organization' do
        before { user.make_student_of! organization }
        before { expect(Mumukit::Platform.organization_class).to receive(:find_by_name!).and_return(organization)}

        it { expect(user.accessible_organizations).to eq [organization] }
        it { expect(user.has_accessible_organizations?).to be true }
        it { expect(user.has_main_organization?).to be true }
        it { expect(user.has_immersive_main_organization?).to be false }

        context 'when immersive' do
          before { organization['immersive?'] = true }
          it { expect(user.has_immersive_main_organization?).to be true }
        end
      end
    end
  end
end
