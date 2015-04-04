class Api::V1::RepliesController < ApplicationController
  ## GET
  # gets the info for a specific reply
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
  # creates a new reply for the given message. this will basically
  # result in the creation of message threads.
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
  # this will delete a reply.
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
