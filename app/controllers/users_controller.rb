class UsersController < ApplicationController
	def user_params
      params.require(:user).permit(:name)
  end

	def index
		@user_info = User.all
		respond_to do |format|
		   format.html
		   format.json  { render :json => @user_info}
		end
	end
end
