Rails.application.routes.draw do

  get 'comments/create'
  get 'comments/destroy'

  resources :articles
  resources :categories

  resources :articles do
    resources :likes
  end

  resources :articles do
    resources :comments
  end

  devise_for :users
  resources :users


  root 'articles#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
