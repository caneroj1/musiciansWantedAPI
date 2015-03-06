class Api::V1::UsersController < ApplicationController
	def index
		@user_info = User.all

		respond_to do |format|
		   format.json  { render :json => @user_info}
		end
	end

	def new
		@new_user = User.new
	end

	def create
		@new_user = User.new(params[:user])
		if @new_user.save
			redirect_to api_users_path
		else
			render "new.html"
		end
	end
end
