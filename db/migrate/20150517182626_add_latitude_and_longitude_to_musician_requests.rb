class AddLatitudeAndLongitudeToMusicianRequests < ActiveRecord::Migration
  def change
    add_column :musician_requests, :latitude, :float
    add_column :musician_requests, :longitude, :float
  end
end
