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

      resources :contactships, defaults: { format: :json }, only: [:create]
      get 'contactships/contacts/:user_id', to: 'contactships#contacts'
      get 'contactships/contacts/:user_id/remove/:contact_id', to: 'contactships#destroy'
      get 'contactships/contacts/:user_id/knows/:contact_id', to: 'contactships#knows'

      get 'notifications', to: 'notifications#notifications', defaults: { format: :json }
      get 'sendEmail', to: 'ses_emails#sendEmail', defaults: { format: :html }
      post 's3ProfilePictureUpload', to: 's3_storages#s3ProfilePictureUpload', defaults: { format: :json }
      post 's3EventPictureUpload', to: 's3_storages#s3EventPictureUpload', defaults: { format: :json }
      get 's3ProfileGet', to: 's3_storages#s3ProfileGet', defaults: { format: :json }
      get 's3EventGet', to: 's3_storages#s3EventGet', defaults: { format: :json }
      get 'checkBounce', to: 'sns_notifications#checkBounce', defaults: { format: :html }
      post 'login', to: 'sessions#login', defaults: { format: :json }
      post 'subscribe', to: 'sns_notifications#subscribe', defaults: { format: :json }
      post 'publish', to: 'sns_notifications#publish', defaults: { format: :json }
      post 'resubscribe', to: 'sns_notifications#resubscribe', defaults: { format: :json }
    end
  end
end
