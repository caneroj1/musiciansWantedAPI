class Reply < ActiveRecord::Base
  attr_accessible :user_id, :body

  validates :body, presence: true

  belongs_to :message
end
