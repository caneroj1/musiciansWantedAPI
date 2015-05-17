class MusicianRequest < ActiveRecord::Base
  attr_accessible :poster, :instrument, :location, :latitude, :longitude

  belongs_to :user

  after_create :create_notification

  def create_notification
    Notification.create(title: "#{poster} is looking for a #{instrument}",
                        notification_type: 2,
                        location: self.location,
                        latitude: self.latitude,
                        longitude: self.longitude,
                        record_id: self.user_id)
  end
end
