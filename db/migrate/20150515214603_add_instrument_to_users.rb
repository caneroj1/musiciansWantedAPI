class AddInstrumentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :instrument, :string, default: ""
  end
end
