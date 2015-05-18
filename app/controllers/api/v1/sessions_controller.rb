class Api::V1::SessionsController < ApplicationController
  def login
    login_success = true
    client = nil

    begin
      client = SoundCloud.new({
        :client_id     => ENV["soundcloud_client_id"],
        :client_secret => ENV["soundcloud_client_secret"],
        :username      => params[:username],
        :password      => params[:password]
      })
    rescue
      login_success = false
    end

    if login_success
      user = find_or_create_user(client)
      if user.errors.empty?
        render json: { user_id: user.id, refresh_token: client.refresh_token }, status: 200
      else
        render json: { errors: user.errors  }, status: 404
      end
    else
      render json: { errors: "There was a problem logging into soundcloud" }, status: 404
    end
  end

  protected
  def find_or_create_user(client)
    user = User.find_by_email(params[:username])
    if user.nil?
      user = User.new(name: client.get('/me').username, email: params[:username])
      user.save
      loadSESClientCreation
			creationEmail(user.email)
    end
    user
  end

  # Load AWS SES Client
  def loadSESClientCreation
    @sesClient = Aws::SES::Client.new(access_key_id: ENV['h_aws_access_key_id'], secret_access_key: ENV['h_aws_secret_access_key'], region: 'us-east-1')


  end

  def creationEmail(email)

    sendTo = "harveyh1@tcnj.edu"

    #Used to send email
    @resp = @sesClient.send_email(
    # required
    source: "harveyh1@tcnj.edu",
    # required
    destination: {
      to_addresses: [email]
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
