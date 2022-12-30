Rails.application.routes.draw do
  resources :sessions, only: [:create]

  resources :category_groups, only: [:index, :show, :update, :create]
  get "category_groups_types", to: "category_groups#types"

  resources :categories, only: [:index, :show, :update, :create]

  resources :payment_methods, only: [:index, :show, :update, :create]

  resources :expenses, only: [:show, :update, :create]

  root "teste#index"
end
