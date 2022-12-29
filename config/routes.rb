Rails.application.routes.draw do
  resources :sessions, only: [:create]

  get "settings", to: "settings#index"

  resources :category_groups, only: [:index, :show, :update, :create]
  get "category_groups_types", to: "category_groups#types"

  resources :categories, only: [:show, :update, :create]

  resources :payment_methods, only: [:show, :update, :create]

  root "teste#index"
end
