Rails.application.routes.draw do
  scope '/account' do
    get '/confirm_email', to: 'users#confirm_email'
  end
  get '/edit_user_password', to: 'sessions#reset_password'
  patch '/edit_user_password', to: 'sessions#update_user_password'
  get '/reset_password', to: 'sessions#forgot_password'
  patch '/reset_password', to: 'sessions#reset_password_link'
  get '/signup', to: 'users#new'
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  namespace :admin do
    resources :branches, :ingredients, :inventories, :meals
  end
  resources :users do
    member do
      get :confirm_email
    end
  end
  resources :users
  root 'store#index', as: 'store_index', via: :all
  get '/', to: 'store#category'
  post '/line_items/:id', to: 'line_items#reduce_quantity'
  resources :carts
  resources :line_items
end
