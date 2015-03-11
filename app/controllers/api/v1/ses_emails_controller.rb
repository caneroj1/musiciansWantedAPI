class Api::V1::SesEmailsController < ApplicationController
  before_action :loadClient
  def loadClient()
    @sesClient = Aws::SES::Client.new(access_key_id: ENV['aws_access_key_id'],secret_access_key: ENV['aws_secret_access_key'],region: 'us-east-1')

  end

  def test()

      # @sesClient.get_send_quota.each do |response|
      #   @resp = response.data.max_send_rate
      # end



      # @sesClient.list_verified_email_addresses.each do |response|
      #   @resp = response.data
      # end

      email = 'testCSC470@mailinator.com'

      @sesClient.verify_email_address(email_address: email)

  end
end
