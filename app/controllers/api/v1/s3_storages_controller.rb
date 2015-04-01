require 'base64'

class Api::V1::S3StoragesController < ApplicationController
  # Used to run loadClient before anything else is run
  before_action :loadS3Client

  # Loads AWS s3 client
  def loadS3Client
    @s3Client = Aws::S3::Client.new(access_key_id: ENV['j_aws_access_key_id'], secret_access_key: ENV['j_aws_secret_access_key'], region: 'us-east-1')

  end

  def s3upload
    # decode the base64 encoded image data
    decodedImage = Base64.decode64(params[:image])

    @s3Client.put_object(bucket: 'musicians-wanted-pics', key: "#{params[:user_id]}_profile_pic.jpg", body: decodedImage)
    render json: { info: "nice", }, status: 202
  end
end
