Rails.application.routes.draw do
  scope :account do
    get :confirm_email, to: 'users#confirm_email'
  end
  get :edit_user_password, to: 'sessions#reset_password'
  patch :edit_user_password, to: 'sessions#update_user_password'
  get :reset_password, to: 'sessions#forgot_password'
  patch :reset_password, to: 'sessions#reset_password_link'
  get :signup, to: 'users#new'
  get :login, to: 'sessions#new'
  post :login, to: 'sessions#create'
  delete :logout, to: 'sessions#destroy'
  namespace :admin do
    resources :branches, except: [:show]
    resources :ingredients, except: [:show]
    resources :inventories, except: [:show]
    resources :meals, except: [:show]
  end
  resources :users, except: [:destroy, :index] do
    member do
      get :confirm_email
    end
  end
  root 'store#index', as: 'store_index', via: :all
  get :category, to: 'store#category', as: 'store_category'
  get :myorders, to: 'users#myorders'
  resources :carts, only: [:update, :destroy]

  resources :line_items do
    member do
      patch :update_quantity
    end
  end

  resources :orders, only: [:create, :new, :destroy ]
  resources :charges, only: [:create, :new]
end
