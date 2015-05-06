class Contactship < ActiveRecord::Base
  attr_accessible :user_id, :contact_id

  validates :contact_id, uniqueness: { scope: :user_id , message: "already exists" }

  belongs_to :user
  belongs_to :contact, class_name: 'User'
end
