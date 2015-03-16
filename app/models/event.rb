class Event < ActiveRecord::Base
  attr_accessible :title, :location, :event_time, :created_by

  validates :title, :location, :event_time, :created_by, presence: true

  # an event has many users attending, but events also belongs to users
  has_and_belongs_to_many :users
end
