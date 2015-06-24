module Refinery
  class TestingGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def rake_db
      rake "refinery_testing:install:migrations"
<<<<<<< HEAD
    end

    def copy_guardfile
      template "Guardfile"
=======
>>>>>>> 2-1-main
    end

    def copy_spec_helper
      directory "spec"
    end

  end
end
