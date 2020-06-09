Rails.application.routes.draw do
  get 'users/new'
  root 'home#index'
  get 'help', to: 'help#index'
  get 'about', to: 'about#index'
  get 'contact', to: 'contact#index'

  get 'signup', to: 'users#new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
