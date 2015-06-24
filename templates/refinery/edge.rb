require 'rbconfig'
<<<<<<< HEAD

gsub_file 'Gemfile', "gem 'jquery-rails'", "gem 'jquery-rails', '~> 2.2.1'"
# We want to ensure that you have an ExecJS runtime available!
begin
  run 'bundle install'
  require 'execjs'
  ::ExecJS::Runtimes.autodetect
rescue
  gsub_file 'Gemfile', "# gem 'therubyracer'", "gem 'therubyracer'"
end

append_file 'Gemfile' do
"

gem 'refinerycms', :git => 'git://github.com/refinery/refinerycms.git'
=======

# We want to ensure that you have an ExecJS runtime available!
begin
  require 'execjs'
rescue LoadError
  abort "ExecJS is not installed. Please re-start the installer after running:\ngem install execjs"
end
>>>>>>> 2-1-main

if File.read("#{destination_root}/Gemfile") !~ /assets.+coffee-rails/m
  gem "coffee-rails", :group => :assets
end

<<<<<<< HEAD
# Specify additional Refinery CMS Engines here (all optional):
gem 'refinerycms-i18n', :git => 'git://github.com/parndt/refinerycms-i18n.git'
#  gem 'refinerycms-blog', :git => 'git://github.com/refinery/refinerycms-blog.git'
#  gem 'refinerycms-inquiries', :git => 'git://github.com/refinery/refinerycms-inquiries.git'
#  gem 'refinerycms-search', :git => 'git://github.com/refinery/refinerycms-search.git'
#  gem 'refinerycms-page-images', :git => 'git://github.com/refinery/refinerycms-page-images.git'
=======
append_file 'Gemfile' do
"
gem 'refinerycms', github: 'refinery/refinerycms', branch: 'master'
>>>>>>> 2-1-main

# Optionally, specify additional Refinery CMS Extensions here:
gem 'refinerycms-acts-as-indexed', '~> 1.0.0'
#  gem 'refinerycms-blog', github: 'refinery/refinerycms-blog', branch: 'master'
#  gem 'refinerycms-inquiries', github: 'refinery/refinerycms-inquiries', branch: 'master'
#  gem 'refinerycms-search', github: 'refinery/refinerycms-search', branch: 'master'
#  gem 'refinerycms-page-images', github: 'refinery/refinerycms-page-images', branch: 'master'
"
end

begin
  require 'execjs'
  ::ExecJS::Runtimes.autodetect
rescue
  gsub_file 'Gemfile', "# gem 'therubyracer'", "gem 'therubyracer'"
end

run 'bundle install'

rake 'db:create'
generate "refinery:cms --fresh-installation #{ARGV.join(' ')}"

say <<-SAY
  ============================================================================
    Your new Refinery CMS application is now running on edge and mounted to /.
  ============================================================================
SAY
