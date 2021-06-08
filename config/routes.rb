Rails.application.routes.draw do

  resources :posts
  get 'comments/create'
  get 'comments/destroy'
  
  
  devise_for :users
  resources :users

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

  root 'articles#index'

  get 'pages/admin'
  get 'pages/about'

  resources :pages do
    member do
      post:confirm_guest_to_user
      post:refuse_guest
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
