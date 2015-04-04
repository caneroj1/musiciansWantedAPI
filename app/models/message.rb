class Message < ActiveRecord::Base
  attr_accessible :subject, :body, :sent_by, :user_id

  validates :subject, :body, presence: true

  belongs_to :user
  has_many :replies
  
  def sender
    User.find_by_id(sent_by)
  end
end
