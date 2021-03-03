Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  root to: 'games#index'

  post 'games/:id/add_to_cart/', to: 'games#add_to_cart', as: 'add_to_cart'
  resources :games, except: [:delete]
  
  resources :tickets, only: %i[show index]
  
  delete 'cart/remove_from_cart', to: 'cart#remove_from_cart', as: 'remove_from_cart'
  post 'cart/adjust_tickets', to: 'cart#adjust_tickets', as: 'adjust_tickets'
  post 'cart/checkout', to: 'cart#checkout', as: 'cart_checkout'
  get 'cart/cancel', to: 'cart#cancel', as: 'cart_cancel'
  get 'cart/success', to: 'cart#success', as: 'cart_success'
  resources :cart, except: [:delete, :show]

  get 'my_account/tickets', to: 'my_account#tickets', as: 'my_tickets'
  resources :my_account, except: [:delete, :show]
end
