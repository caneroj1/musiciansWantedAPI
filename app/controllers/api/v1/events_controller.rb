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

end
