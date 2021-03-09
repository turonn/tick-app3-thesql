Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  root to: 'games#index'

  post 'games/:id/add_to_cart/', to: 'games#add_to_cart', as: 'add_to_cart'
  resources :games, except: [:delete]
  
  resources :tickets, only: %i[show index]
  
  delete 'cart/remove_from_cart', to: 'cart#remove_from_cart', as: 'remove_from_cart'
  post 'cart/adjust_tickets', to: 'cart#adjust_tickets', as: 'adjust_tickets'
#  post 'cart/send_to_stripe', to: 'cart#send_to_stripe', as: 'send_to_stripe'
#  post 'cart/create_payment_intent', to: 'cart#create_payment_intent', as: 'create_payment_intent'
  post 'cart/checkout', to: 'cart#checkout', as: 'cart_checkout'
  get 'cart/cancel', to: 'cart#cancel', as: 'cart_cancel'
  get 'cart/success', to: 'cart#success', as: 'cart_success'
  get 'cart/success/clear', to: 'cart#clear', as: 'cart_success_clear'
  resources :cart, except: [:delete, :show]

  get 'my_account/tickets', to: 'my_account#tickets', as: 'my_tickets'
  resources :my_account, except: [:delete, :show]

  resources :webhooks, only: [:create]

  resources :scanner, only: [:update]
end
