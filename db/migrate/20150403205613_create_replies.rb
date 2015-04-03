class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|

      t.timestamps null: false
    end
  end
end
