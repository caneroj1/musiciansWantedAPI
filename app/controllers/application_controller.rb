class ApplicationController < ActionController::Base
  # restrict access to the api if we are not in development mode
  before_action :whitelist, if: :not_development?

  private
  # this method is called before every request coming in to the API
  # it checks if the user cannot access the api. if the user cannot access it,
  # they are returned empty data and the request is marked unauthorized.
  def whitelist
    if cannot_access_api?
      render json: [], status: :unauthorized
    end
  end

  # the user cannot access the api if they are not on executing a GET request
  # and they do not have the correct access token
  def cannot_access_api?
    !request.env["REQUEST_METHOD"].eql?("GET") &&
    !request.headers['mw-token'].eql?(ENV["api_access_token"])
  end

  # if the rails app is in development mode, we do not want to have all of our requests contain the api token
  # that would be annoying and break forms and stuff.
  def not_development?
    !Rails.env.eql?("development")
  end
end
