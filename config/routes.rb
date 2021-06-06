Rails.application.routes.draw do

  resources :posts
  get 'comments/create'
  get 'comments/destroy'

  resources :articles
  resources :categories
  resources :guests

  resources :articles do
    resources :likes
  end

  resources :articles do
    resources :comments
  end

  resources :articles do
    member do
      delete :delete_file
    end
  end

  devise_for :users
  resources :users


  root 'articles#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
