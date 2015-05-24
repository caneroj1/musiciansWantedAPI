class Api::V1::SessionsController < ApplicationController
  def login
    response = User.try(:find_by_email, params[:email]).try(:authenticate, params[:password])
    if response
      render json: { user_id: response.id }, status: 200, location: [:api, response]
    else
      render json: { errors: "The username or password entered was incorrect." }, status: 422
    end
  end
end
