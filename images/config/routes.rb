<<<<<<< HEAD
Refinery::Core::Engine.routes.prepend do
  match '/system/images/*dragonfly', :to => Dragonfly[:refinery_images]
=======
Refinery::Core::Engine.routes.draw do
  get '/system/images/*dragonfly', :to => Dragonfly[:refinery_images]
>>>>>>> 2-1-main

  namespace :admin, :path => Refinery::Core.backend_route do
    resources :images, :except => :show do
      get :insert, :on => :collection
    end
  end
end
