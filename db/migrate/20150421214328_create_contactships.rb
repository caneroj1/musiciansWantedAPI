class CreateContactships < ActiveRecord::Migration
  def change
    create_table :contactships do |t|
      t.integer :user_id
      t.integer :contact_id

      t.timestamps null: false
    end
  end
end
