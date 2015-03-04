class UsersController < ApplicationController
	def index
		respond_to do |format|
		   format.html { }
		   format.json  { render :json => "name": "John", "age": 45 }
		end
	end
end
