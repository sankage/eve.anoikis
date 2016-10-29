Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/auth/:provider/callback", to: "sessions#create"
  get "/signin", to: "sessions#new"
  delete "/signout", to: "sessions#destroy"

  resources :solar_systems, only: [:show], path: "systems"  do
    resources :signatures, only: [:create, :destroy, :edit, :update] do
      post "batch_create", on: :collection
    end
    resources :notes, only: [:create, :destroy]
    get "set_destination", on: :member
  end

  resources :tabs, only: [:create, :destroy] do
    get "switch", on: :member
  end

  mount ActionCable.server => "/cable"

  require 'sidekiq/web'

  constraints lambda {|request|  Pilot.find_by(id: request.session["pilot_id"])&.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end
end
