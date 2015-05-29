class Api::V1::SnsNotificationsController < ApplicationController
  # Used to run loadClient before anything else is run
  before_action :loadSNSClient

  # Load AWS SES Client
  def loadSNSClient
    @snsClient = Aws::SNS::Client.new(access_key_id: ENV['h_aws_access_key_id'],
                                      secret_access_key: ENV['h_aws_secret_access_key'],
                                      region: 'us-east-1')
  end

  def checkBounce
    @resp = @snsClient.list_subscriptions
  end

  ## POST
  # @api_description
  # @action=subscribe
  # Subscribes the parameter's cell number to our AWS SNS notifications topic.
  # The route also performs validation to see if it is in this format: 1-xxx-xxx-xxxx.
  # The cell number must be unique, and if the subscriber is unable to update their cell number because of this,
  # then we return with an error.
  # This route should ONLY be used when the user is creating their first subscription.
  # Params: id, cell
  # @end_description
  def subscribe
    if /1-[0-9]{3}-[0-9]{3}-[0-9]{4}/.match(params[:cell])
      subscriber = User.find_by_id(params[:id])
      result = {}
      if subscriber
        begin
          if subscriber.update(cell: reformat_number(params[:cell]))
            response = @snsClient.subscribe(topic_arn: ENV["sms_topic_arn"], protocol: "sms", endpoint: params[:cell])
            result = { subscription: response.subscription_arn, status: 201 }
          else
            result = { errors: subscriber.errors.messages, status: 422 }
          end
        rescue Aws::SNS::Errors::InvalidParameter => e
          result = { errors: "we encountered a problem", status: 422 }
        end
      else
        result = { errors: "user does not exist", status: 422}
      end
    else
      result = { errors: "invalid number", status: 422 }
    end

    status = result.delete(:status)
    render json: result, status: status
  end

  ## POST
  # @api_description
  # @action=resubscribe
  # This route will change a user's subscription. It has to find the user's subscription in the list of subs
  # maintained by Amazon. It searches by the cell number for a subscriotion, and once it finds the subscription, it is deleted
  # and then the user is resubscribed with the different cell number.
  # Params: id, cell
  # @end_description
  def resubscribe
    if /1-[0-9]{3}-[0-9]{3}-[0-9]{4}/.match(params[:cell])
      subscriber = User.find_by_id(params[:id])
      result = {}

      if subscriber
        begin
          target = subscriber.cell

          reformatted_number = reformat_number(params[:cell])
          if subscriber.update(cell: reformatted_number)
            next_token = nil
            found = false
            loop do
              @snsClient.list_subscriptions_by_topic(topic_arn: ENV["sms_topic_arn"], next_token: next_token).each do |sub|
                found_sub = sub.subscriptions.select { |scrip| scrip.endpoint.eql?(target) }.first

                if found_sub
                  @snsClient.unsubscribe(subscription_arn: found_sub.subscription_arn)
                  response = @snsClient.subscribe(topic_arn: ENV["sms_topic_arn"], protocol: "sms", endpoint: reformatted_number)
                  result = { subscription: response.subscription_arn, status: 201 }
                  found = true
                  break
                end
                next_token = sub.next_token
              end
              break unless next_token
            end
            if !found
              response = @snsClient.subscribe(topic_arn: ENV["sms_topic_arn"], protocol: "sms", endpoint: reformatted_number)
              result = { subscription: response.subscription_arn, status: 201 }
            end
          else
            result = { errors: subscriber.errors.messages, status: 422 }
          end
        end
      else
        result = { errors: "user does not exist", status: 422 }
      end
    else
      result = { errors: "invalid number", status: 422 }
    end

    status = result.delete(:status)
    render json: result, status: status
  end

  ## POST
  # @api_description
  # @action=publish
  # This route publishes a notification to the subscribers of the AWS topic. If the action is successful,
  # we return a success message, otherwise we rescue any exceptions and return that as the error message.
  # Params: message, subject
  # @end_description
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
