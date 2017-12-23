Rails.application.routes.draw do
  scope '/account' do
    get '/confirm_email', to: 'users#confirm_email'
  end
  get '/edit_user_password', to: 'sessions#get_user_new_password'
  patch '/edit_user_password', to: 'sessions#update_user_new_password'
  get '/reset_password', to: 'sessions#get_user_email'
  post '/reset_password', to: 'sessions#find_user_by_email'
  get '/signup', to: 'users#new'
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  resources :users do
    member do
      get :confirm_email
    end
  end
  resources :users
  root 'sessions#new', as: 'login_index', via: :all
end
