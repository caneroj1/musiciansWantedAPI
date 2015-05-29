class Api::V1::UsersController < ApplicationController

	## GET
	# @api_description
	# @action=index
	# This route returns all users in json format.
	# @end_description
	def index
		respond_to do |format|
	  	format.json  { render json: User.all }
		end
	end

	## GET
	# @api_description
	# @action=show
	# This route will return data for an individual user in json format. The user is specified by the id
	# parameter in the route.
	# Params: id
	# @end_description
	def show
		respond_to do |format|
			format.json { render json: User.find_by_id(params[:id]) }
		end
	end

	## POST
	# @api_description
	# @action=create
	# This route accepts a hash of user attributes in order to create and save a new user.
	# If the action is successful, then we return the new user in json format.
	# If the action is unsuccessful, we return the errors.
	# Params: user_attributes(name, email, age, location, looking_for_band, looking_to_jam, search_radius,
	# gender)
	# @end_description
	def create
		new_user = User.new(params[:user])
		if new_user.save
			render json: new_user, status: 201, location: [:api, new_user]
			# Emails::WelcomeEmail.send(params[:user][:email])
		else
			render json: { errors: new_user.errors }, status: 422
		end
	end

	## PUT/PATCH
	# @api_description
	# This route accepts a hash of user attributes that will be used to update the user's information.
	# If the action is successful, then we return the updated user in json format.
	# If the action is unsuccessful, we return the errors.
	# Params: user_attributes(name, email, age, location, looking_for_band, looking_to_jam, search_radius,
	# gender, location)
	# @action=update
	# @end_description
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
	# @api_description
	# This route destroys the specified user according to the id passed in the params.
	# If it is successful, it returns a success message, otherwise it returns and error messasge.
	# Params: id
	# @action=destroy
	# @end_description
	def destroy
		delete_user = User.find_by_id(params[:id])

		if !delete_user.nil? && delete_user.delete
			render json: { info: "delete successful" }, status: 200, location: [:api, delete_user]
		else
			render json: { errors: "delete unsuccessful" }, status: 422
		end
	end

	## GET
	# @api_description
	# This route returns all of the events created by the specified user in json format.
	# Params: id
	# @action=get_events
	# @end_description
	def get_events
		results = Event.where("created_by = ?", params[:id])
		render json: results, status: 200
	end

	## GET
	# @api_description
	# @action=get_messages
	# This route returns json data for all of the received messages sent to the specified user.
	# Params: id
	# @end_description
	def get_messages
		user = User.find_by_id(params[:id])

		if !user.nil?
			render json: user.messages, status: 200
		else
			render json: { errors: "that user does not exist" }, status: 422
		end
	end

	## GET
	# @api_description
	# @action=get_sent_messages
	# This route returns json data for all of the messages that the specified user has sent.
	# Params: id
	# @end_description
	def get_sent_messages
		user = User.find_by_id(params[:id])

		if !user.nil?
			sent_messages = Message.where("sent_by = ?", params[:id])
			render json: sent_messages, status: 200
		else
			render json: { errors: "that user does not exist" }, status: 422
		end
	end

	## GET
	# @api_description
	# @action=near_me
	# This route does a search with the geocoder and finds all users that are close to the specified
	# user. Closeness is defined in terms of the specified user's search radius.
	# Params: id
	# @end_description
	def near_me
		user = User.find_by_id(params[:id])

		if !user.nil?
			results = User.near(user.location, user.search_radius).where("id != ?", params[:id])
			render json: results, status: 200, location: [:api, user]
		else
			render json: { errors: "that user does not exist" }, status: 422
		end
	end

	## GET
	# @api_description
	# @action=events_near_me
	# This route does a search with the geocoder and finds all the events close to the specified
	# user. Closeness is defined in terms of the specified user's search radius.
	# Params: id
	# @end_description
	def events_near_me
		user = User.find_by_id(params[:id])

		if !user.nil?
			results = Event.near(user.location, user.search_radius)
			render json: results, status: 200, location: [:api, user]
		else
			render json: { errors: "that user does not exist" }, status: 422
		end
	end

	## GET
	# @api_description
	# @action=attending
	# This route returns a list of events that the specified user is attending.
	# Params: id
	# @end_description
	def attending
		results = User.try(:find_by_id, params[:id]).try(:events)

		if results
			render json: results, status: 200
		else
			render json: { errors: "user not found" }, status: 422
		end
	end
end
