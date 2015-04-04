class AddAttributesToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :subject, :string
    add_column :messages, :body, :string
    add_column :messages, :sent_by, :integer
  end
end
