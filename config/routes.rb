Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/auth/:provider/callback", to: "sessions#create"
  get "/signin", to: "sessions#new"
  delete "/signout", to: "sessions#destroy"
end
