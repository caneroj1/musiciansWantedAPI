require 'base64'

class Api::V1::S3StoragesController < ApplicationController
  # Used to run loadClient before anything else is run
  before_action :loadS3Client

  # Loads AWS s3 client
  def loadS3Client
    @s3Client = Aws::S3::Client.new(access_key_id: ENV['j_aws_access_key_id'],
                                    secret_access_key: ENV['j_aws_secret_access_key'],
                                    region: 'us-east-1')
  end

  ## POST
  # @api_description
  # @action=s3ProfilePictureUpload
  # This route accepts Base64 encoded image data and uploads our s3 storage bucket. This stores the associated image
  # with a user.
  # Params: image, user_id
  # @end_description
  def s3ProfilePictureUpload
    # decode the base64 encoded image data
    decodedImage = Base64.decode64(params[:image])

    user = User.find_by_id(params[:user_id])
    @s3Client.put_object(bucket: 'musicians-wanted-pics', key: "#{params[:user_id]}_profile_pic.jpg", body: decodedImage)

    user.has_profile_pic = true
    user.save

    render json: { info: "picture upload was successful", }, status: 202
  end

  ## POST
  # @api_description
  # @action=s3EventPictureUpload
  # This route accepts Base64 encoded image data and uploads our s3 storage bucket. This stores the associated image
  # with an event.
  # Params: image, event_id
  # @end_description
  def s3EventPictureUpload
    # decode the base64 encoded image data
    decodedImage = Base64.decode64(params[:image])

    event = Event.find_by_id(params[:event_id])
    @s3Client.put_object(bucket: 'musicians-wanted-pics', key: "#{params[:event_id]}_event_pic.jpg", body: decodedImage)

    event.has_event_pic = true
    event.save

    render json: { info: "picture upload was successful", }, status: 202
  end

  ## GET
  # @api_description
  # This route accepts a user id and returns the profile image associated with that user. The image returned
  # will either be a Base64 encoded image or it will be nil, if the user has not uploaded an image.
  # Params: user_id
  # @action=s3ProfileGet
  # @end_description
  def s3ProfileGet
    user = User.find_by_id(params[:user_id])
    response = nil

    if user.has_profile_pic
      s3_response = @s3Client.get_object(bucket: 'musicians-wanted-pics', key: "#{params[:user_id]}_profile_pic.jpg")
      response_body = s3_response.data.body.read
      response = Base64.encode64(response_body)
    end

    render json: { picture: response }, status: 200
  end

  ## GET
  # @api_description
  # This route accepts an event id and returns the event image associated with that event. The image returned
  # will either be a Base64 encoded image or it will be nil, if the event has no uploaded image.
  # Params: event_id
  # @action=s3EventGet
  # @end_description
  def s3EventGet
    event = Event.find_by_id(params[:event_id])
    response = nil

    if event.has_event_pic
      s3_response = @s3Client.get_object(bucket: 'musicians-wanted-pics', key: "#{params[:event_id]}_event_pic.jpg")
      response_body = s3_response.data.body.read
      response = Base64.encode64(response_body)
    end

    render json: { picture: response }, status: 200
  end
end
