require 'rbconfig'
<<<<<<< HEAD
VERSION_BAND = '2.0.0'

gsub_file 'Gemfile', "gem 'jquery-rails'", "gem 'jquery-rails', '~> 2.2.1'"
# We want to ensure that you have an ExecJS runtime available!
begin
  run 'bundle install'
  require 'execjs'
  ::ExecJS::Runtimes.autodetect
rescue
  require 'pathname'
  if Pathname.new(destination_root.to_s).join('Gemfile').read =~ /therubyracer/
    gsub_file 'Gemfile', "# gem 'therubyracer'", "gem 'therubyracer'"
  else
    append_file 'Gemfile', <<-GEMFILE

group :assets do
  # Added by Refinery. We want to ensure that you have an ExecJS runtime available!
  gem 'therubyracer'
end
GEMFILE
  end
=======
VERSION_BAND = '2.1.0'

# We want to ensure that you have an ExecJS runtime available!
begin
  require 'execjs'
rescue LoadError
  abort "ExecJS is not installed. Please re-start the installer after running:\ngem install execjs"
end

if File.read("#{destination_root}/Gemfile") !~ /assets.+coffee-rails/m
  gem "coffee-rails", :group => :assets
>>>>>>> 2-1-main
end

append_file 'Gemfile', <<-GEMFILE

# Refinery CMS
gem 'refinerycms', '~> #{VERSION_BAND}', :git => 'git://github.com/refinery/refinerycms.git', :branch => '2-0-stable'

<<<<<<< HEAD
# Specify additional Refinery CMS Extensions here (all optional):
gem 'refinerycms-i18n', '~> #{VERSION_BAND}'
=======
# Optionally, specify additional Refinery CMS Extensions here:
gem 'refinerycms-acts-as-indexed', '~> 1.0.0'
>>>>>>> 2-1-main
#  gem 'refinerycms-blog', '~> #{VERSION_BAND}'
#  gem 'refinerycms-inquiries', '~> #{VERSION_BAND}'
#  gem 'refinerycms-search', '~> #{VERSION_BAND}'
#  gem 'refinerycms-page-images', '~> #{VERSION_BAND}'
GEMFILE

<<<<<<< HEAD

=======
begin
  require 'execjs'
  ::ExecJS::Runtimes.autodetect
rescue
  gsub_file 'Gemfile', "# gem 'therubyracer'", "gem 'therubyracer'"
end
>>>>>>> 2-1-main

run 'bundle install'

rake 'db:create'
generate "refinery:cms --fresh-installation #{ARGV.join(' ')}"

say <<-SAY
  ============================================================================
    Your new Refinery CMS application is now installed and mounts at '/'
  ============================================================================
SAY
