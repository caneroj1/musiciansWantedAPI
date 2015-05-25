class Api::V1::MessagesController < ApplicationController
  ## GET
  # show. returns the json for a message
  def show
    message = Message.find_by_id(params[:id]) || { error: "not found" }
    status = !message.class.eql?(Hash) ? 200 : 500
    render json: message, status: status
  end

  ## POST
  # create. this will create a new message, and add it
  # to the messages of the specified user, as well as
  # mark it as being sent from the user who sent the request
  def create
    # find the user we will add the message to
    user = User.find_by_id(params[:message][:user_id])
    new_message = Message.new(params[:message])

    if !user.nil? && user.messages << new_message
      render json: new_message, status: 201, location: [:api, new_message]
    else
      errors = !user.nil? ? new_message.errors : "There was a problem creating that message"
      render json: { errors: errors }, status: 422
    end
  end

  ## DELETE
  # destroys the specified message
  def destroy
    delete_message = Message.find_by_id(params[:id])

    if !delete_message.nil? && delete_message.delete
      render json: { info: "delete successful" }, status: 200, location: [:api, delete_message]
    else
      render json: { errors: "delete unsuccessful" }, status: 422
    end
  end

  ## PATCH
  # update. changes the attributes of the message
  def update
    update_message = Message.find_by_id(params[:id])

    if update_message.try(:update, params[:message])
      render json: update_message, status: 200, location: [:api, update_message]
    else
      errors = update_message.try(:errors) || "something went wrong"
      render json: { errors: errors }, status: 422
    end
  end
end
