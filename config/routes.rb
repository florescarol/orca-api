Rails.application.routes.draw do
  resources :sessions, only: [:create]

  get "reports/expenses", to: "reports#expenses"
  get "reports/payment_methods", to: "reports#payment_methods"

  resources :category_groups, only: [:index, :show, :update, :create]
  get "category_groups_types", to: "category_groups#types"

  resources :categories, only: [:index, :show, :update, :create]

  resources :payment_methods, only: [:index, :show, :update, :create]

  resources :expenses, only: [:show, :update, :create]

  root "teste#index"
end
