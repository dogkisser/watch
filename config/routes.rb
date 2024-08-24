Rails.application.routes.draw do
  root "feed#index"

  post "register", to: "users#create"
end
