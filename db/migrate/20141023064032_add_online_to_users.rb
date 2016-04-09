class AddOnlineToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_online, :boolean
  end
end
