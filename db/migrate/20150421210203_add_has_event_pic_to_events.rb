class AddHasEventPicToEvents < ActiveRecord::Migration
  def change
    change_column :events, :has_event_pic, :boolean, default: false
  end
end
