Rails.application.routes.draw do
  root "feed#index"

  resources :users
  resource :sessions, only: %i[new create destroy]
end
