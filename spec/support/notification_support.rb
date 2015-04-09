def create_notifications(user)
  10.times { |i| Notification.create(title: "#{user.name} #{i}", notification_type: 1, location: user.location, longitude: user.longitude, latitude: user.latitude) }
  10.times { |i| Notification.create(title: "Event #{i} by #{user.name}", notification_type: 0, location: user.location, longitude: user.longitude, latitude: user.latitude) }
end
