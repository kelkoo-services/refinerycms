<<<<<<< HEAD
Refinery::Core::Engine.routes.prepend do
  namespace :admin, :path => 'refinery' do
=======
Refinery::Core::Engine.routes.draw do
  namespace :admin, :path => Refinery::Core.backend_route do
>>>>>>> 2-1-main
    get 'dashboard', :to => 'dashboard#index', :as => :dashboard
  end
end
