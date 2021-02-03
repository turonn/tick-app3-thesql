Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "home#index"

  resources :games, except: [:delete] do
    member do
      post :add_to_cart
      post :remove_from_cart
    end
  end
  resources :tickets, only: [:show, :index]
  resources :users, except: [:delete]
  resources :cart, except: [:delete]
end
