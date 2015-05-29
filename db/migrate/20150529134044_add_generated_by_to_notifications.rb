class AddGeneratedByToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :generated_by, :integer
  end
end
