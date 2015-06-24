module Refinery
  module Testing
    module ControllerMacros
      module Authentication
        def self.extended(base)
          base.send :include, Devise::TestHelpers
        end

<<<<<<< HEAD
        def login_user
          let(:user) { FactoryGirl.create(:user) }
          before(:each) do
            @request.env["devise.mapping"] = Devise.mappings[:admin]
            sign_in user
          end
        end

        def login_refinery_user
          let(:refinery_user) { FactoryGirl.create(:refinery_user) }
          before(:each) do
            @request.env["devise.mapping"] = Devise.mappings[:admin]
            sign_in refinery_user
=======
        def refinery_login_with(*roles)
          mock_user roles
        end

        def refinery_login_with_factory(factory)
          factory_user factory
        end

        def mock_user(roles)
          let(:controller_permission) { true }
          roles = handle_deprecated_roles! roles
          let(:logged_in_user) do
            user = double 'Refinery::User', :username => 'Joe Fake'

            roles.each do |role|
              user.stub(:has_role?).with(role).and_return true
            end
            user.stub(:has_role?).with(:superuser).and_return false if roles.exclude? :superuser

            user
          end

          before do
            controller.should_receive(:require_refinery_users!).and_return false
            controller.should_receive(:authenticate_refinery_user!).and_return true
            controller.should_receive(:restrict_plugins).and_return true
            controller.should_receive(:allow_controller?).and_return controller_permission
            controller.stub(:refinery_user?).and_return true
            controller.stub(:current_refinery_user).and_return logged_in_user
          end
        end

        def factory_user(factory)
          let(:logged_in_user) { FactoryGirl.create factory }
          before do
            @request.env["devise.mapping"] = Devise.mappings[:admin]
            sign_in logged_in_user
>>>>>>> 2-1-main
          end
        end

        def login_user
          Refinery.deprecate :login_user, :when => '2.2', :replacement => 'refinery_login_with :user'
          refinery_login_with :user
        end

        def login_refinery_user
          Refinery.deprecate :login_refinery_user, :when => '2.2', :replacement => 'refinery_login_with :refinery_user'
          refinery_login_with :refinery_user
        end

        def login_refinery_superuser
<<<<<<< HEAD
          let(:refinery_superuser) { FactoryGirl.create(:refinery_superuser) }
          before(:each) do
            @request.env["devise.mapping"] = Devise.mappings[:admin]
            sign_in refinery_superuser
          end
        end

        def login_refinery_translator
          let(:refinery_translator) { FactoryGirl.create(:refinery_translator) }
          before(:each) do
            @request.env["devise.mapping"] = Devise.mappings[:admin]
            sign_in refinery_translator
          end
=======
          Refinery.deprecate :login_refinery_superuser, :when => '2.2', :replacement => 'refinery_login_with :refinery_superuser'
          refinery_login_with :refinery_superuser
        end

        def login_refinery_translator
          Refinery.deprecate :login_refinery_translator, :when => '2.2', :replacement => 'refinery_login_with :refinery_translator'
          refinery_login_with :refinery_translator
        end

        private
        def handle_deprecated_roles!(*roles)
          mappings = {
            :user => [],
            :refinery_user => [:refinery],
            :refinery_superuser => [:refinery, :superuser],
            :refinery_translator => [:refinery, :translator]
          }
          mappings[roles.first] || roles
>>>>>>> 2-1-main
        end
      end
    end
  end
end
