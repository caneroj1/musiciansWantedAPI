class Api::V1::SnsNotificationsController < ApplicationController
  # Used to run loadClient before anything else is run
  before_action :loadSNSClient

  # Load AWS SES Client
  def loadSNSClient
    @snsClient = Aws::SNS::Client.new(access_key_id: ENV['h_aws_access_key_id'], secret_access_key: ENV['h_aws_secret_access_key'], region: 'us-east-1')
  end

  def checkBounce()
    @resp = @snsClient.list_subscriptions()
  end
end
