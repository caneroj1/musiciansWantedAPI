require 'api_constraints'

Rails.application.routes.draw do
  root "welcome#index"

  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, defaults: { format: :json }, except: [:edit, :new] do
        member do
          get 'events', to: 'users#get_events'
          get 'messages', to: 'users#get_messages'
          get 'sent_messages', to: 'users#get_sent_messages'
          get 'near_me', to: 'users#near_me'
          get 'events_near_me', to: 'users#events_near_me'
        end
      end

      resources :events, defaults: { format: :json }, except: [:edit, :new] do
        member do
          get 'creator', to: 'events#get_event_creator'
          get 'attendees', to: 'events#get_event_attendees'
          post 'attend', to: 'events#attend_event'
        end
      end

      resources :messages, defaults: { format: :json }, except: [:index, :update, :edit, :new] do
        resources :replies, defaults: { format: :json }, only: [:index, :create, :destroy, :show]
      end

      get 'sendEmail', to: 'ses_emails#sendEmail', defaults: { format: :html }
      post 's3upload', to: 's3_storages#s3upload', defaults: { format: :json }
      get 's3get', to: 's3_storages#s3get', defaults: { format: :json }
      get 'checkBounce', to: 'sns_notifications#checkBounce', defaults: { format: :html }
      post 'login', to: 'sessions#login', defaults: { format: :json }
    end
  end
end
