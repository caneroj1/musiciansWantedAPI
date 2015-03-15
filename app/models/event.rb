class Event < ActiveRecord::Base
  attr_accessible :title, :location, :event_time

  validates :title, :location, :event_time, presence: true
end
