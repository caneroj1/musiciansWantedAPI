class Api::V1::SesEmailsController < ApplicationController
  # Used to run loadClient before anything else is run
  before_action :loadSESClient

  # Load AWS SES Client
  def loadSESClient()
    @sesClient = Aws::SES::Client.new(access_key_id: ENV['SES_aws_access_key_id'],secret_access_key: ENV['SES_aws_secret_access_key'],region: 'us-east-1')
    puts "Your environment variable should print out below"
    environment = ENV['S3_aws_access_key_id']
    myVar = "==========  #{environment}  =========="

    puts myVar

  end

  def test()

      # @sesClient.get_send_quota.each do |response|
      #   @resp = response.data.max_send_rate
      # end



      # @sesClient.list_verified_email_addresses.each do |response|
      #   @resp = response.data
      # end

      email = 'testCSC470@mailinator.com'


      puts "Have I broken yet"
      @sesClient.verify_email_address(email_address: email)

      @resp = "Verification Email Sent"

  end
end
