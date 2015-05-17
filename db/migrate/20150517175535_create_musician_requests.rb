class CreateMusicianRequests < ActiveRecord::Migration
  def change
    create_table :musician_requests do |t|
      t.string  :poster
      t.string  :instrument
      t.string  :location
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
