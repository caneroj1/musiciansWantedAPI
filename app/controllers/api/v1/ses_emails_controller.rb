class Api::V1::SesEmailsController < ApplicationController
  # Used to run loadClient before anything else is run
  before_action :loadSESClient

  # Load AWS SES Client
  def loadSESClient
    @sesClient = Aws::SES::Client.new(access_key_id: ENV['h_aws_access_key_id'], secret_access_key: ENV['h_aws_secret_access_key'], region: 'us-east-1')


  end

  def sendEmail()

    sendTo = "harveyh1@tcnj.edu"


    if params[:email].nil? == false
      sendTo = params[:email]
    end

    #Used to send email
    @resp = @sesClient.send_email(
    # required
    source: "harveyh1@tcnj.edu",
    # required
    destination: {
      to_addresses: [sendTo]
    },
    # required
    message: {
      # required
      subject: {
        # required
        data: "Welcome to Musicians Wanted!",
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
          data: "Thanks for signing up for Musicians Wanted! <br> <br> We hope you enjoy the application!! <br> <br> Thanks,<br>The Musicians Wanted Development Team",
          charset: "UTF-8",
        },
      },
    },
    reply_to_addresses: ["musicianswanted@do-not-reply.com"],
    return_path: "harveyh1@tcnj.edu",
  )

  end
end
