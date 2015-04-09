class Notification < ActiveRecord::Base
  attr_accessible :title, :location, :type, :latitude, :longitude

  validates :title, :type, presence: true

  geocoded_by :location

  before_create :correct_title

  def correct_title
    self.title =
    if type.eql?(0)
      "Event: #{self.title} was created."
    else
      "#{self.title} created an account."
    end
  end
end
