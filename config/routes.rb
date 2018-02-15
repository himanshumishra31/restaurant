Rails.application.routes.draw do

  controller :registrations do
    get :signup, action: :new
    post :signup, action: :create
  end

  controller :registrations do
    get :confirm_email, path: "registrations/:id/confirm_email"
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
      patch :update_status, on: :member
      get :show_comments, on: :member
    end
    resources :reports, only: [:index]
    resources :orders do
      member do
        patch :toggle_ready_status
        patch :toggle_pick_up_status
      end
      get :update_orders, on: :collection
    end
  end

  resources :users, only: [:edit, :update] do
    get :myorders, on: :collection
    resources :orders, only: [:create, :new, :destroy]
  end

  controller :orders do
    get :feedback, path: 'orders/:id/feedback'
  end

  root 'store#index', as: 'store_index'
  get :category, to: 'store#category', as: 'store_category'
  get :switch_branch, controller: :store

  resources :line_items do
    patch :update_quantity, on: :member
  end

  resources :carts, only: [:update, :destroy]
  resources :charges, only: [:create, :new]

  controller :ratings do
    put :rate_meals
  end
  match "*path" => redirect("/"), via: [:get]
end
