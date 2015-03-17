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
end
