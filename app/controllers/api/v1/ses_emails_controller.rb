class Api::V1::SesEmailsController < ApplicationController
  # Used to run loadClient before anything else is run
  before_action :loadSESClient

  # Load AWS SES Client
  def loadSESClient
    @sesClient = Aws::SES::Client.new(access_key_id: ENV['h_aws_access_key_id'], secret_access_key: ENV['h_aws_secret_access_key'], region: 'us-east-1')

  end

  def sendEmail()

    #Used to send email
    @resp = @sesClient.send_email(
    # required
    source: "csc470harvey@mailinator.com",
    # required
    destination: {
      to_addresses: ["csc470hank@mailinator.com"],
      cc_addresses: ["harveyh1@tcnj.edu"]
    },
    # required
    message: {
      # required
      subject: {
        # required
        data: "Testing SES to non verified",
        charset: "UTF-8",
      },
      # required
      body: {
        text: {
          # required
          data: "I hope this delivers with no errors",
          charset: "UTF-8",
        },
        html: {
          # required
          data: "I have no clue what this is used for",
          charset: "UTF-8",
        },
      },
    },
    reply_to_addresses: ["csc470harvey@mailinator.com"],
    return_path: "csc470harvey@mailinator.com",
  )

  #Used to get send quote
  # @sesClient.get_send_quota.each do |response|
  #   @resp = response.data.max_send_rate
  # end


  # #Used to list verified email addresses
  # @sesClient.list_verified_email_addresses.each do |response|
  #   @resp = response.data
  # end

  #Used to send verification email
  # email = 'testCSC470@mailinator.com'
  #
  #
  # puts "Have I broken yet"
  # @sesClient.verify_email_address(email_address: email)

  end
end
