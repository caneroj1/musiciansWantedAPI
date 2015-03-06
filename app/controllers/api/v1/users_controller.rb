class Api::V1::UsersController < ApplicationController
	def index
		@user_info = User.all
		
		respond_to do |format|
		   format.json  { render :json => @user_info}
		end
	end
end
