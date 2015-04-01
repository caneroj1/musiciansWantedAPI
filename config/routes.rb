require 'api_constraints'

Rails.application.routes.draw do
  root "welcome#index"

  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, defaults: { format: :json } do
        member do
          get 'events', to: 'users#get_events'
        end
      end

      resources :events, defaults: { format: :json } do
        member do
          get 'creator', to: 'events#get_event_creator'
          get 'attendees', to: 'events#get_event_attendees'
          post 'attend', to: 'events#attend_event'
        end
      end

      get 'sendEmail', to: 'ses_emails#sendEmail', defaults: { format: :html }
      post 's3upload', to: 's3_storages#s3upload', defaults: { format: :json }
      get 'checkBounce', to: 'sns_notifications#checkBounce', defaults: { format: :html }
      post 'login', to: 'sessions#login', defaults: { format: :json }
    end
  end
end
