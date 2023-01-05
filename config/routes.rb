Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "success", to: "pages#success"

  get "my_profile", to: "users#my_profile"

  get "my_profile", to: "users#show"

  post "my_profile", to: "users#cancel_subscription"

  post "my_profile/pause", to: "users#pause_subscription"

  post "my_profile/unpause", to: "users#unpause_subscription"

  post "my_profile/upgrade", to: "users#upgrade"

  resources :plans, only: :create
end
