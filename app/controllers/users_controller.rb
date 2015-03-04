class UsersController < ApplicationController

	def index
		respond_to do |format|
		  format.html { }
		  format.json  { render json: "String" }
		end
	end
end
