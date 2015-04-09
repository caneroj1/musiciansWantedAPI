class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :title, default: ""
      t.string :location, default: ""
      t.float :latitude
      t.float :longitude
      t.integer :type
      t.timestamps null: false
    end
  end
end
