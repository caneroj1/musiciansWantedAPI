class User < ActiveRecord::Base
	attr_accessible :name, :email, :age, :location, :looking_for_band,
									:looking_to_jam, :has_profile_pic, :search_radius, :gender, :longitude, :latitude

	validates :name, :email, presence: true
	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: %q{is not valid} },
										uniqueness: true
	validates :search_radius, numericality: { less_than_or_equal_to: 20, greater_than_or_equal_to: 5 }
	validates :gender, inclusion: { in: ["male", "female", "none"], message: %q{needs to selected.} }

	# perform custom validation on the age
	validate :validate_age_on_create_or_update

	# a user can have many events and they can also belong to many events
	has_and_belongs_to_many :events
	has_many :messages

	# for location services
	geocoded_by :location
	after_validation :geocode

	after_create :create_notification

	# a user's age must be an integer >= 1 or it can be nil if the user does not
	# want to disclose their age.
	def validate_age_on_create_or_update
		if !age.nil? && age < 1 && !age.class.eql?(Integer)
			errors.add(:age, %q{is invalid. It must be nil or an integer >= 1.})
		end
	end

	# returns all of the messages this user sent
	def sent_messages
		Message.where("sent_by = ?", id)
	end

	# creates a notification that a user was created
	def create_notification
		Notification.create(title: self.name,
												notification_type: 1,
												location: self.location,
												latitude: self.latitude,
												longitude: self.longitude,
												record_id: self.id)
	end
end
