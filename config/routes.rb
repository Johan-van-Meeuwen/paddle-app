Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "success", to: "pages#success"

  get "/my_profile", to: "users#my_profile"

  get "/preview_transaction", to: "pricing#preview_monthly_transaction"

  get "/create_monthly_transaction", to: "pricing#create_monthly_transaction"

  get "/save_customer", to: "checkout#save_customer"

  get "/my_profile/preview_pro_upgrade", to: "users#preview_pro_upgrade"

  get "/my_profile/pro_upgrade", to: "users#pro_upgrade"

  get "/my_profile/pro_priority_upgrade", to: "users#pro_priority_upgrade"

  get "/my_profile/list_transaction_information", to: "users#list_transaction_information"

  post "/my_profile/cancel", to: "users#cancel_subscription"

  get "/my_profile/addresses", to: "users#list_addresses"

  get "/my_profile/businesses", to: "users#list_businesses"

  get "/review", to: "pages#review"

  resources :plans, only: :create
end
