class AddSeenByAttributesToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :seen_by_sender, :boolean, default: false
    add_column :messages, :seen_by_receiver, :boolean, default: false
  end
end
