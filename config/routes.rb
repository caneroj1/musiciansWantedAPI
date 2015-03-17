require 'api_constraints'

Rails.application.routes.draw do
  root "welcome#index"

  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, defaults: { format: :json }
      get 'sendEmail', to: 'ses_emails#sendEmail', defaults: { format: :html }
    end
  end
end
