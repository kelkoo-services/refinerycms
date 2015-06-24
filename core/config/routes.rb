Refinery::Core::Engine.routes.draw do
  filter(:refinery_locales) if defined?(RoutingFilter::RefineryLocales) # optionally use i18n.
  get 'wymiframe(/:id)', :to => 'fast#wymiframe', :as => :wymiframe
  get "#{Refinery::Core.backend_route}/message", :to => 'fast#message', :as => :message

  namespace :admin, :path => Refinery::Core.backend_route do
    root :to => 'dashboard#index'
    resources :dialogs, :only => [:index, :show]
  end

<<<<<<< HEAD
  match '/refinery/update_menu_positions', :to => 'admin/core#update_plugin_positions'
=======
  post "/#{Refinery::Core.backend_route}/update_menu_positions", :to => 'admin/core#update_plugin_positions'
>>>>>>> 2-1-main

  get '/sitemap.xml' => 'sitemap#index', :defaults => { :format => 'xml' }
end
