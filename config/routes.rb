Rails.application.routes.draw do
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
    resources :branches, :ingredients, :inventories, :reports
    get :update_orders, to: 'orders#update_orders'
    resources :orders do
      member do
        patch :toggle_ready_status
        patch :toggle_pick_up_status
      end
    end
    resources :meals do
      member do
        get :show_comments
      end
    end
  end
  resources :users do
    member do
      get :confirm_email
    end
  end

  resources :orders do
    member do
      get :feedback
    end
  end
  root 'store#index', as: 'store_index', via: :all
  get '/category', to: 'store#category', as: 'store_category'
  post '/line_items/:id', to: 'line_items#reduce_quantity'
  get '/myorders', to: 'users#myorders'
  resources :carts
  resources :line_items
  resources :orders
  resources :charges
  resources :ratings do
    collection do
      put :rate_meals
    end
  end
end
