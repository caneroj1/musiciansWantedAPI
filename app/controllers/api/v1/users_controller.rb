class Api::V1::UsersController < ApplicationController
	## GET
	# returns all users in json format.
	def index
		user_info = User.all

		respond_to do |format|
	  	format.json  { render :json => user_info}
		end
	end

	## GET
	# has a new_user instance variable passed to the view. this will be used to create a new
	# user in the create action. we should probably get rid of this action/route when we go live.
	def new
		@new_user = User.new
	end

	## GET
	# this action will return data for an individual user in json format. the user is specified by the id
	# parameter in the route.
	def show
		respond_to do |format|
			format.json { render json: User.find(params[:id]) }
		end
	end

	## POST
	# accepts a hash of user attributes in order to create and save a new user.
	def create
		new_user = User.new(params[:user])
		if new_user.save
			render json: new_user, status: 201, location: [:api, new_user]
		else
			render json: { errors: new_user.errors }, status: 422
		end
	end

	## PUT/PATCH
	# accepts a hash of user attributes that will be used to update the user's information
	def update
		update_user = User.find(params[:id])

		if update_user.update(params[:user])
			render json: update_user, status: 200, location: [:api, update_user]
		else
			render json: { errors: update_user.errors }, status: 422
		end
	end
end
