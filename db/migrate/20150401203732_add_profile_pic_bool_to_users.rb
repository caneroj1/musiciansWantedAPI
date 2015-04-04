class AddProfilePicBoolToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_profile_pic, :boolean, default: false
  end
end
