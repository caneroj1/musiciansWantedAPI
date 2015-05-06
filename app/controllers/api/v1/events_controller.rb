class Api::V1::EventsController < ApplicationController

  ## GET
  # returns all of the events
  def index
    respond_to do |format|
      format.json { render json: Event.all }
    end
  end

  ## GET
  # returns json information for a specific event
  def show
    respond_to do |format|
      format.json { render json: Event.find(params[:id]) }
    end
  end

  ## POST
  # creates an event according to params that are passed in
  # adds the creator of the event to the list of attendees
  def create
    new_event = Event.new(params[:event])
    user = User.find_by_id(new_event.created_by)

    if !user.nil? && new_event.valid?
      #new_event.users << user
      new_event.save
      
      render json: new_event, status: 201, location: [:api, new_event]
    else
      errors = user.nil? ? "there was a problem creating this event" : new_event.errors
      render json: { errors: errors }, status: 422
    end
  end

  ## PUT/PATCH
  # updates an event according to the passed in params
  def update
    update_event = Event.find_by_id(params[:id])

    if !update_event.nil? && update_event.update(params[:event])
      render json: update_event, status: 200, location: [:api, update_event]
    else
      errors = !update_event.nil? ? update_event.errors : "update unsuccessful"
      render json: { errors: errors }, status: 422
    end
  end

  ## DELETE
  # destroys an event according to the passed in params[:id]
  def destroy
    delete_event = Event.find_by_id(params[:id])

    if !delete_event.nil? && delete_event.delete
      render json: { info: "delete successful" }, status: 200, location: [:api, delete_event]
    else
      render json: { errors: "delete unsuccessful" }, status: 422
    end
  end

  ## GET
  # get the user that created the specified event
  def get_event_creator
    event = Event.find_by_id(params[:id])

    if !event.nil?
      render json: User.find_by_id(event.created_by), status: 200, location: [:api, event]
    else
      render json: { errors: "unsuccessful query to get event creator" }, status: 422
    end
  end

  ## GET
  # get the list of users that are attending the specified event.
  # this includes the user who created the event.
  def get_event_attendees
    event = Event.find_by_id(params[:id])

    if !event.nil?
      render json: event.users, status: 200, location: [:api, event]
    else
      render json: { errors: "unsuccessful query to get event attendees" }, status: 422
    end
  end

  ## POST
  # this will add the specified user to the indicated event
  def attend_event
    event = Event.find_by_id(params[:id])
    user = User.find_by_id(params[:user_id])

    if !event.nil? && !user.nil? && !event.users.include?(user)
      event.users << user
      render json: "", status: 204, location: [:api, event]
    else
      render json: { errors: "there was a problem with the user attending that event" }, status: 422
    end
  end
end
