require 'api_constraints'

Rails.application.routes.draw do

  namespace :api do

  root "welcome#index"

  namespace :api, defaults: { format: :json } do
    master
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, defaults: { format: :json }
      get 'test', to: 'ses_emails#test'
    end
  end
end
