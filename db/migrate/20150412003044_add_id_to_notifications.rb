class AddIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :record_id, :integer
  end
end
