require 'base64'

class Api::V1::S3StoragesController < ApplicationController
  # Used to run loadClient before anything else is run
  before_action :loadS3Client

  # Loads AWS s3 client
  def loadS3Client
    @s3Client = Aws::S3::Client.new(access_key_id: ENV['j_aws_access_key_id'], secret_access_key: ENV['j_aws_secret_access_key'], region: 'us-east-1')

  end

  def s3ProfilePictureUpload
    # decode the base64 encoded image data
    decodedImage = Base64.decode64(params[:image])

    user = User.find_by_id(params[:user_id])
    @s3Client.put_object(bucket: 'musicians-wanted-pics', key: "#{params[:user_id]}_profile_pic.jpg", body: decodedImage)

    user.has_profile_pic = true
    user.save

    render json: { info: "picture upload was successful", }, status: 202
  end

  def s3EventPictureUpload
    # decode the base64 encoded image data
    decodedImage = Base64.decode64(params[:image])

    event = Event.find_by_id(params[:event_id])
    @s3Client.put_object(bucket: 'musicians-wanted-pics', key: "#{params[:events_id]}_event_pic.jpg", body: decodedImage)

    event.has_profile_pic = true
    event.save

    render json: { info: "picture upload was successful", }, status: 202
  end

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

  def s3EventGet
    event = Event.find_by_id(params[:event_id])
    response = nil

    if event.has_profile_pic
      s3_response = @s3Client.get_object(bucket: 'musicians-wanted-pics', key: "#{params[:event_id]}_event_pic.jpg")
      response_body = s3_response.data.body.read
      response = Base64.encode64(response_body)
    end

    render json: { picture: response }, status: 200
  end
end
