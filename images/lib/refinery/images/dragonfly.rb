require 'dragonfly'

module Refinery
  module Images
    module Dragonfly

      class << self
        def setup!
          app_images = ::Dragonfly[:refinery_images]
          app_images.configure_with(:imagemagick)

          app_images.define_macro(::Refinery::Image, :image_accessor)

          app_images.analyser.register(::Dragonfly::ImageMagick::Analyser)
          app_images.analyser.register(::Dragonfly::Analysis::FileCommandAnalyser)
        end

        def configure!

          app_images = ::Dragonfly[:refinery_images]

          # Next we define the url for our processed images, overriding the default .url method...

          app_images.configure_with(:rails) do |c|
            c.datastore.root_path = Refinery::Images.datastore_root_path
            c.url_format = Refinery::Images.dragonfly_url_format
            c.secret = Refinery::Images.dragonfly_secret
            c.trust_file_extensions = Refinery::Images.trust_file_extensions

            c.define_url do |app_images, job, opts|
              thumb = Refinery::Thumb.find_by_job(job.serialize)
              # If (the job fetch 'image_uid' then resize to '40x40') has been stored already..
              # then serve the url from the datastore filesystem, s3, etc
              if thumb
                p app_images.datastore
                app_images.datastore.url_for(thumb.uid)
              else
                # ...otherwise if the job hasn't been stored, serve it from the Dragonfly server as usual
                app_images.server.url_for(job)
              end
            end

            c.server.before_serve do |job, env|
              uid = job.store
              # Keep track of its uid
              # Holds all the job info, e.g fetch 'image_uid' then resize to '40x40'
              Refinery::Thumb.create!( :uid => uid, :job => job.serialize )
            end
          end

          if ::Refinery::Images.s3_backend
            app_images.datastore = ::Dragonfly::DataStorage::S3DataStore.new
            app_images.datastore.configure do |s3|
              s3.bucket_name = Refinery::Images.s3_bucket_name
              s3.access_key_id = Refinery::Images.s3_access_key_id
              s3.secret_access_key = Refinery::Images.s3_secret_access_key
              # S3 Region otherwise defaults to 'us-east-1'
              s3.region = Refinery::Images.s3_region if Refinery::Images.s3_region
            end
          end

        end

        def attach!(app)
          ### Extend active record ###
          app.config.middleware.insert_before Refinery::Images.dragonfly_insert_before,
                                              'Dragonfly::Middleware', :refinery_images

          app.config.middleware.insert_before 'Dragonfly::Middleware', 'Rack::Cache', {
            :verbose     => Rails.env.development?,
            :metastore   => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'meta')}",
            :entitystore => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'body')}"
          }
        end

      end

    end
  end
end
