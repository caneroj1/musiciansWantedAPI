class Api::V1::SnsNotificationsController < ApplicationController
  # Used to run loadClient before anything else is run
  before_action :loadSNSClient

  # Load AWS SES Client
  def loadSNSClient
    @snsClient = Aws::SNS::Client.new(access_key_id: ENV['h_aws_access_key_id'], secret_access_key: ENV['h_aws_secret_access_key'], region: 'us-east-1')
  end

  def checkBounce
    @resp = @snsClient.list_subscriptions
  end

  ## POST
  # subscribes the cell number to our AWS SNS notifications topic.
  # performs validation to see if it is in this format: 1-xxx-xxx-xxxx
  def subscribe
    if /1-[0-9]{3}-[0-9]{3}-[0-9]{4}/.match(params[:cell])
      begin
        response = @snsClient.subscribe(topic_arn: ENV["sms_topic_arn"], protocol: "sms", endpoint: params[:cell])
      rescue Aws::SNS::Errors::InvalidParameter => e
        render json: { errors: "we encountered a problem" }, status: 422
      else
        render json: { subscription: response.subscription_arn }, status: 201
      end
    else
      render json: { errors: "invalid number" }, status: 422
    end
  end

  ## POST
  # publishes a notification to the subscribers of the AWS topic
  def publish
    begin
      @snsClient.publish({
        topic_arn: ENV["sms_topic_arn"],
        message: params[:message],
        subject: params[:subject]
      })
    rescue => e
      render json: { errors: e }, status: 422
    else
      render json: { info: "success!" }, status: 201
    end
  end
end
