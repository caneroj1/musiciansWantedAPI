class AddNewAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :looking_for_band, :boolean, default: false
    add_column :users, :looking_to_jam, :boolean, default: false
  end
end
