class AddAttributesToReply < ActiveRecord::Migration
  def change
    add_column :replies, :body, :string
    add_column :replies, :user_id, :integer
  end
end
