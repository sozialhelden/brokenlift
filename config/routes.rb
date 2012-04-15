Brokenlifts::Application.routes.draw do
  devise_for :users

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  root :to => "home#index"

  resources :stations, :only => [:index, :show]

  # api namespace
  namespace :api do
    resources :lifts, :only  => [:index, :show] do
      resources :events, :only  => [:index, :show]
      collection do
        get 'broken'
      end
      member do
        get 'statistics'
      end
    end

    resources :events, :only  => [:index, :show]

    resources :stations, :only  => [:index, :show] do
      resources :lifts, :only  => [:index, :show]
      collection do
        get 'status'
      end
    end

    resources :manufacturers, :only  => [:index, :show]

    resources :lines, :only  => [:index, :show] do
      resources :stations, :only  => [:index, :show]
    end

    resources :operators, :only  => [:index, :show] do
        resources :lifts, :only  => [:index, :show]
    end
  end

end

