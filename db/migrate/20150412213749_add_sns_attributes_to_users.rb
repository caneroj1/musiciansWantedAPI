class AddSnsAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cell, :string, default: ""
    add_index :users, :cell
  end
end
