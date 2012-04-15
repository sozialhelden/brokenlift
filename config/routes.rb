Brokenlifts::Application.routes.draw do
  devise_for :users

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  namespace :api do
    resources :lifts,         :only  => [:index, :show] do
      resources :events,        :only  => [:index, :show]
      collection do
        get 'broken'
      end
      member do
        get 'statistics'
      end
    end

    resources :events,        :only  => [:index, :show]

    resources :stations,      :only  => [:index, :show] do
      resources :lifts,         :only  => [:index, :show]
      collection do
        get 'status'
      end
    end
    resources :manufacturers, :only  => [:index, :show]

    resources :lines,         :only  => [:index, :show] do
      resources :stations,      :only  => [:index, :show]
    end
    resources :operators, :only  => [:index, :show] do
        resources :lifts,         :only  => [:index, :show]
    end
  end
  
  resources :stations, :only => [:index, :show]
  
  resources :lifts, :only => [:index]

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

