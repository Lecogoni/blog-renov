Rails.application.routes.draw do

  resources :articles
  resources :categories
  resources :guests
  resources :posts
  devise_for :users,
    controllers: {:registrations => "registrations"}
  resources :users

  root 'articles#index'

  get 'comments/create'
  get 'comments/destroy'
  

  resources :articles do
    resources :likes
  end

  resources :articles do
    resources :comments
  end

  resources :users do
    member do
      delete :delete_avatar_attachment
    end
  end

  resources :articles do
    member do
      delete :delete_file
    end
  end


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
