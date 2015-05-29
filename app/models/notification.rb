class Notification < ActiveRecord::Base
  attr_accessible :title, :location, :notification_type, :latitude, :longitude, :record_id, :generated_by

  validates :title, :notification_type, presence: true

  geocoded_by :location

  before_create :correct_title

  def correct_title
    self.title =
    if notification_type.eql?(0)
      "Event: #{self.title} was created."
    elsif notification_type.eql?(1)
      "#{self.title} created an account."
    else
      "#{self.title}"
    end
  end
end
