require 'api_constraints'

Rails.application.routes.draw do
  root "api/v1/users#index"

  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, defaults: { format: :json }
    end
  end
end
