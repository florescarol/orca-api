Rails.application.routes.draw do
  resources :sessions, only: [:create]

  resources :category_groups, only: [:show, :update, :create]

  get "category_groups_types", to: "category_groups#types"

  root "teste#index"
end
