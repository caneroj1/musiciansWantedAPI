class Api::V1::S3StoragesController < ApplicationController
  # Used to run loadClient before anything else is run
  # before_action :loadS3Client
  #
  # # Loads AWS s3 client
  # def loadS3Client()
  #   # @sesClient = Aws::SES::Client.new(access_key_id: ENV['aws_access_key_id'],secret_access_key: ENV['aws_secret_access_key'],region: 'us-east-1')
  #
  # end
end
