class Notification < ActiveRecord::Base
  attr_accessible :title, :location, :notification_type, :latitude, :longitude, :record_id

  validates :title, :notification_type, presence: true

  geocoded_by :location

  before_create :correct_title

  def correct_title
    self.title =
    if notification_type.eql?(0)
      "Event: #{self.title} was created."
    else
      "#{self.title} created an account."
    end
  end
end
