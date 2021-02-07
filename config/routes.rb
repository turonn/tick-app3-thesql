Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "home#index"

  resources :games, except: [:delete]
  post 'games/:id/add_to_cart/', to: 'games#add_to_cart', as: 'add_to_cart'
  delete 'games/:id/remove_from_cart', to: 'games#remove_from_cart', as: 'remove_from_cart'

  resources :tickets, only: [:show, :index]
  resources :users, except: [:delete]
  resources :cart, except: [:delete]
  post 'cart/:id/:ticket_count/adjust_tickets/', to: 'cart#adjust_tickets', as: 'adjust_tickets'
end
