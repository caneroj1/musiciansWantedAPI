class Api::V1::SessionsController < ApplicationController

  ## POST
  # @api_description
  # @action=login
  # This route will try to authenticate a user via email and password. If authentication is successful, the response
  # will be the id of the user. If authentication is unsuccessful, response will be an error message.
  # Params: email, password
  # @end_description
  def login
    response = User.try(:find_by_email, params[:email]).try(:authenticate, params[:password])
    if response
      render json: { user_id: response.id }, status: 200, location: [:api, response]
    else
      render json: { errors: "The username or password entered was incorrect." }, status: 422
    end
  end
end
