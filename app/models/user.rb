class User < ActiveRecord::Base
	attr_accessible :name, :email, :age, :location

	validates :name, :email, presence: true
	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: %q{is not correct} }

	# perform custom validation on the age
	validate :validate_age_on_create_or_update

	# a user's age must be an integer >= 1 or it can be nil if the user does not
	# want to disclose their age.
	def validate_age_on_create_or_update
		if !age.nil? && age < 1 && !age.class.eql?(Integer)
			errors.add(:age, %q{is invalid. It must be nil or an integer >= 1.})
		end
	end
end
