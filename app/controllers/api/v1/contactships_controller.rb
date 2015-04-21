class Api::V1::ContactshipsController < ApplicationController
  ## GET
  # this will return all contact pairs if there is no user id provided,
  # but if a user id is passed in, it will return all of the contacts for the specified user
  def index
    status = 200
    response = { }

    if params.has_key?(:id)
      user = User.find_by_id(params[:id])
      if user.nil?
        response = { :errors => "That user does not exist" }
        status = 422
      else
        response = user.contacts
        status = 200
      end
    else
      response = Contactship.all
      status = 200
    end

    render json: response, status: status
  end
end
