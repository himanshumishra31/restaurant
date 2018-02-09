Rails.application.routes.draw do

  controller :registrations do
    get :signup, action: :new
    post :signup, action: :create
  end

  resources :registrations, only: [] do
    get :confirm_email, on: :member
  end

  resources :passwords, only: [:new, :edit, :create, :update]

  controller :sessions do
    get :login, action: :new
    post :login, action: :create
    delete :logout, action: :destroy
  end

  namespace :admin do
    resources :branches, except: [:show] do
      patch :change_default, on: :member
    end
    resources :ingredients, except: [:show]
    resources :inventories, except: [:show]
    resources :meals, except: [:show] do
      patch :toggle_meal_status, on: :member
    end
    resources :reports, only: [:index]
    resources :orders do
      member do
        patch :toggle_ready_status
        patch :toggle_pick_up_status
      end
      get :update_orders, on: :collection
    end
    resources :meals do
      member do
        get :show_comments
      end
    end
  end

  resources :users, only: [:edit, :update] do
    get :myorders, on: :collection
    resources :orders, only: [:create, :new, :destroy]
  end

  resources :orders, only: [] do
    member do
      get :feedback
    end
  end

  root 'store#index', as: 'store_index'
  get :category, to: 'store#category', as: 'store_category'
  get :switch_branch, controller: :store

  resources :line_items do
    member do
      patch :update_quantity
    end
  end

  resources :carts, only: [:update, :destroy]
  resources :charges, only: [:create, :new]

  controller :ratings do
    put :rate_meals
  end
  match "*path" => redirect("/"), via: [:get]
end
