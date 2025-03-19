Rails.application.routes.draw do
  namespace :api do
    resources :tests, only: [:index]
  end

  root to: "pages#index"

  get "*path", to: "pages#index", constraints: lambda { |request|
    !request.xhr? && request.format.html?
  }
end
