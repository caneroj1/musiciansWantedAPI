class Event < ActiveRecord::Base
  attr_accessible :title, :location, :description, :event_time, :created_by

  validates :title, :location, :description, :event_time, :created_by, presence: true

  # an event has many users attending, but events also belongs to users
  has_and_belongs_to_many :users

  # for location services
	geocoded_by :location
	after_validation :geocode

  after_create :create_notification

  # creates a notification that an event was created
	def create_notification
		Notification.create(title: self.title,
												notification_type: 0,
												location: self.location,
												latitude: self.latitude,
												longitude: self.longitude,
                        record_id: self.id)
	end
end
