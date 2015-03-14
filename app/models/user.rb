class User < ActiveRecord::Base
	attr_accessible :name, :email, :age

	validates :name, :email, presence: true
	validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end
