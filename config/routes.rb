Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    member do
      get :confirm_email
    end
  end

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
  end
  get '/signup', to: 'users#new'

  scope '/account' do
    get '/confirm_email', to: 'users#confirm_email'
  end
  resources :users
  resources :password_resets, only: [:new, :edit, :create, :update]
end
