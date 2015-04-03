class Api::V1::UsersController < ApplicationController
	## GET
	# returns all users in json format.
	def index
		respond_to do |format|
	  	format.json  { render json: User.all }
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
			format.json { render json: User.find_by_id(params[:id]) }
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
		update_user = User.find_by_id(params[:id])

		# remove email address from the params if it is the same
		params[:user].delete_if { |key, value| value.eql?(update_user.email) && key.eql?("email")}

		if !update_user.nil? && update_user.update(params[:user])
			render json: update_user, status: 200, location: [:api, update_user]
		else
			errors = !update_user.nil? ? update_user.errors : "update unsuccessful"
			render json: { errors: errors }, status: 422
		end
	end

	## DELETE
	# destroys the specified user according to the passed in params
	def destroy
		delete_user = User.find_by_id(params[:id])

		if !delete_user.nil? && delete_user.delete
			render json: { info: "delete successful" }, status: 200, location: [:api, delete_user]
		else
			render json: { errors: "delete unsuccessful" }, status: 422
		end
	end

	## GET
	# gets the list of this user's events
	def get_events
		user = User.find_by_id(params[:id])

		if !user.nil?
			render json: user.events, status: 200, location: [:api, user]
		else
			render json: { errors: "there was a problem getting the events for that user" }, status: 422
		end
	end

end
