require 'api_constraints'

Rails.application.routes.draw do
  root "welcome#index"

  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, defaults: { format: :json }
      resources :events, defaults: { format: :json }
      get 'sendEmail', to: 'ses_emails#sendEmail', defaults: { format: :html }
      get 's3upload', to: 's3_storages#s3upload', defaults: { format: :html }
    end
  end
end
