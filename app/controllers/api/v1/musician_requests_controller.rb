class Api::V1::MusicianRequestsController < ApplicationController

  ## POST
  # @api_description
  # @action=create
  # This route creates a new musician request for the specified user.
  # This results in the creation of a notification that will alert nearby users that
  # a new musician request has been created.
  # Params: user_id, instrument
  # @end_description
  def create
    user = User.find_by_id(params[:user_id])
    request = user.musician_requests.new( poster: user.name,
                                          instrument: params[:musician_request][:instrument],
                                          location: user.location,
                                          latitude: user.latitude,
                                          longitude: user.longitude)
    if request.save
      render json: request, status: 201
    else
      render json: { errors: request.errors }, status: 422
    end
  end
end
