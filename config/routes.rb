Rails.application.routes.draw do
  get "/games", to: "games#index"

  namespace :api do
    resources :tests, only: [:index]
  end

  root to: "pages#index"
end
