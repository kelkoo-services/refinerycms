module Refinery
  module Resources
    class Engine < ::Rails::Engine
      extend Refinery::Engine

      isolate_namespace Refinery
      engine_name :refinery_resources

      config.autoload_paths += %W( #{config.root}/lib )

<<<<<<< HEAD
      initializer 'attach-refinery-resources-with-dragonfly', :after => :load_config_initializers do |app|
=======
      initializer 'attach-refinery-resources-with-dragonfly', :before => :build_middleware_stack do |app|
>>>>>>> 2-1-main
        ::Refinery::Resources::Dragonfly.configure!
        ::Refinery::Resources::Dragonfly.attach!(app)
      end

      initializer "register refinery_files plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_files'
          plugin.menu_match = /refinery\/(refinery_)?(files|resources)$/
<<<<<<< HEAD
          plugin.version = %q{2.0.0}
=======
>>>>>>> 2-1-main
          plugin.activity = { :class_name => :'refinery/resource' }
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.admin_resources_path }
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Resources)
      end
    end
  end
end
