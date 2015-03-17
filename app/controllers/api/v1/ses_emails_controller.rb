class Api::V1::SesEmailsController < ApplicationController
  # Used to run loadClient before anything else is run
  before_action :loadSESClient

  # Load AWS SES Client
  def loadSESClient
    @sesClient = Aws::SES::Client.new(access_key_id: ENV['j_aws_access_key_id'], secret_access_key: ENV['j_aws_secret_access_key'], region: 'us-east-1')

  end

  def sendEmail()

    #Used to send email
    @resp = @sesClient.send_email(
    # required
    source: "harveyh1@tcnj.edu",
    # required
    destination: {
      to_addresses: ["harveyh1@tcnj.edu"]
    },
    # required
    message: {
      # required
      subject: {
        # required
        data: "Testing SES to Non-Verified",
        charset: "UTF-8",
      },
      # required
      body: {
        text: {
          # required
          data: "Musicians Wanted",
          charset: "UTF-8",
        },
        html: {
          # required
          data: "Greeting from Musicians Wanted",
          charset: "UTF-8",
        },
      },
    },
    reply_to_addresses: ["harveyh1@tcnj.edu"],
    return_path: "harveyh1@tcnj.edu",
  )

  #Used to get send quote
  # @sesClient.get_send_quota.each do |response|
  #   @resp = response.data.max_send_rate
  # end


  # #Used to list verified email addresses
  # @sesClient.list_verified_email_addresses.each do |response|
  #   @resp = response.data
  # end

  # #Used to send verification email
  # email = 'harveyh1@tcnj.edu'
  #
  # @sesClient.verify_email_address(email_address: email)

  end
end
