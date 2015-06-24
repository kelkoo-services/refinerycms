require 'spec_helper'

module Refinery
  module Admin
    describe CoreController do
<<<<<<< HEAD
      login_refinery_user

      it "updates the plugin positions" do
        plugins = refinery_user.plugins.reverse.collect(&:name)

        post 'update_plugin_positions', :menu => plugins

        refinery_user.plugins.reload
        refinery_user.plugins.each_with_index do |plugin, idx|
=======
      refinery_login_with_factory :refinery_user

      it "updates the plugin positions" do
        plugins = logged_in_user.plugins.reverse.map &:name

        post 'update_plugin_positions', :menu => plugins

        logged_in_user.plugins.reload.each_with_index do |plugin, idx|
>>>>>>> 2-1-main
          plugin.name.should eql(plugins[idx])
        end
      end
    end
  end
end
