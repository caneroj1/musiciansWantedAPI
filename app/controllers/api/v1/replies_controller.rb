class Api::V1::RepliesController < ApplicationController
  ## GET
  # @api_description
  # @action=index
  # Returns json for all of the replies associated with a given message.
  # Params: message_id
  # @end_description
  def index
    message = Message.find_by_id(params[:message_id])

    if message.nil?
      render json: { errors: "message does not exist" }, status: 422
      return
    end

    render json: message.replies, status: 200
  end

  ## GET
  # @api_description
  # @action=show
  # Returns json data for the reply specified by id under the message specified by message_id.
  # Params: message_id, id
  # @end_description
  def show
    message = Message.find_by_id(params[:message_id])

    if message.nil?
      render json: { errors: "message does not exist" }, status: 422
      return
    end

    reply = message.replies.find_by_id(params[:id])
    if !reply.nil?
      render json: reply, status: 200, location: [:api, message, reply]
    else
      render json: { errors: "reply not found" }, status: 422
    end

  end

  ## POST
  # @api_description
  # Creates a new reply for the given message and returns json for the new reply.
  # Params: message_id, body, user_id
  # @action=create
  # @end_description
  def create
    message = Message.find_by_id(params[:message_id])

    if message.nil?
      render json: { errors: "message does not exist" }, status: 422
      return
    end

    reply = message.replies.new(params[:reply])

    if reply.save
      render json: reply, status: 201, location: [:api, message, reply]
    else
      render json: { errors: reply.errors }, status: 422
    end
  end

  ## DELETE
  # @api_description
  # @action=destroy
  # This will delete a reply from a message's list of replies. If the operation is successful,
  # returns a success message, otherwise returns an error message.
  # Params: message_id, id
  # @end_description
  def destroy
    message = Message.find_by_id(params[:message_id])

    if message.nil?
      render json: { errors: "message does not exist" }, status: 422
      return
    end

    reply = message.replies.find_by_id(params[:id])

    if !reply.nil? && reply.delete
      render json: { info: "delete successful" }, status: 200
    else
      render json: { errors: "delete unsuccessful" }, status: 422
    end
  end
end
