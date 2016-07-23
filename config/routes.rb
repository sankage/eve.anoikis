Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/auth/:provider/callback", to: "sessions#create"
  get "/signin", to: "sessions#new"
  delete "/signout", to: "sessions#destroy"

  resources :solar_systems, only: [:show], path: "systems"  do
    resources :signatures, only: [:create, :destroy, :edit, :update] do
      post "batch_create", on: :collection
    end
    get "system_names", on: :collection
  end

  get "pilot_locations", to: "pilots#locations"

  mount ActionCable.server => "/cable"
end
