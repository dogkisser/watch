Rails.application.routes.draw do
  root "feed#index"

  resources :users
end
