class AddInformationToEvents < ActiveRecord::Migration
  def change
    add_column :events, :event_time, :datetime
    add_column :events, :title, :string
    add_column :events, :location, :string
  end
end
