Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    scope module: :v1 do
      resources :users, defaults: { format: :json }
    end
  end
end
