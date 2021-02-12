Rails.application.routes.draw do
  get 'home/index'
  devise_for :users
  resources :users
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "users#index"
  get 'home' => 'home#index'
  get '/contactosfallidos' => 'contactos#fallidos'
  get '/archivos' => 'archivos#index'
  resources :contactos
end
