Rails.application.routes.draw do
  resources :sessions, only: [:new, :destroy]
  resources :users do
    member do
      get :googleplus, :gmail, :calendar
    end
  end

  root "pages#googleplus"

  match "/auth/:provider/callback", to: "sessions#create",                   via: :get
  match "/signin",                  to: "sessions#new",     as: :sign_in,    via: :get
  match "/signout",                 to: "sessions#destroy", as: :sign_out,   via: :delete
  match "/googleplus",              to: "pages#googleplus", as: :googleplus, via: :get
  match "/gmail",                   to: "pages#gmail",      as: :gmail,      via: :get
  match "/calendar",                to: "pages#calendar",   as: :calendar,   via: :get
end
