Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  root to: 'games#index'

  resources :games, except: [:delete]
  post 'games/:id/add_to_cart/', to: 'games#add_to_cart', as: 'add_to_cart'
  delete 'games/:id/remove_from_cart', to: 'games#remove_from_cart', as: 'remove_from_cart'

  resources :tickets, only: %i[show index]

  resources :cart, except: [:delete]
  post 'cart/adjust_tickets', to: 'cart#adjust_tickets', as: 'adjust_tickets'
  post 'cart/checkout', to: 'cart#checkout', as: 'cart_checkout'

  resources :my_account, except: [:delete]
  get 'my_account/tickets', to: 'my_account#tickets', as: 'my_tickets'
end
