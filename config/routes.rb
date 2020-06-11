Rails.application.routes.draw do
  root 'home#index'
  get 'help', to: 'help#index'
  get 'about', to: 'about#index'
  get 'contact', to: 'contact#index'

  get 'signup', to: 'users#new'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
