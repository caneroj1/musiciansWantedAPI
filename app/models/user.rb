class User < ActiveRecord::Base
	attr_accessible :name, :email, :age, :location, :looking_for_band, :looking_to_jam, :has_profile_pic

	validates :name, :email, presence: true
	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: %q{is not valid} }
	validates :email, uniqueness: true

	# perform custom validation on the age
	validate :validate_age_on_create_or_update

	# a user can have many events and they can also belong to many events
	has_and_belongs_to_many :events
	has_many :messages

	# for location services
	geocoded_by :location
	after_validation :geocode

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
end
