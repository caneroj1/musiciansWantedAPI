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
  def create
    new_event = Event.new(params[:event])
    if new_event.save
      render json: Event.create(params[:event]), status: 201, location: [:api, new_event]
    else
      render json: { errors: new_event.errors }, status: 422
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
end
