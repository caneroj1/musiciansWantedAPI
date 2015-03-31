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
    end
    user
  end
end
