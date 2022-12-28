Rails.application.routes.draw do
  resources :sessions, only: [:create]

  root "teste#index"
end
