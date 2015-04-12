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
  # performs validation to see if it is in this format: 1-xxx-xxx-xxxx.
  # also, the cell must be unique, and if the subscriber cannot update their cell number, then we return with an error.
  # this route should ONLY be used when the user is creating their first subscription.
  def subscribe
    if /1-[0-9]{3}-[0-9]{3}-[0-9]{4}/.match(params[:cell])
      subscriber = User.find_by_id(params[:id])
      result = {}
      begin
        if subscriber.update(cell: reformat_number(params[:cell]))
          response = @snsClient.subscribe(topic_arn: ENV["sms_topic_arn"], protocol: "sms", endpoint: params[:cell])
          result = { subscription: response.subscription_arn, status: 201 }
        else
          result = subscriber.errors.messages.merge({ status: 422 })
        end
      rescue Aws::SNS::Errors::InvalidParameter => e
        result = { errors: "we encountered a problem", status: 422}
      end
    else
      result = { errors: "invalid number", status: 422}
    end

    status = result.delete(:status)
    render json: result, status: status
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

  private
  def reformat_number(cell)
    cell.gsub("-", "")
  end
end
