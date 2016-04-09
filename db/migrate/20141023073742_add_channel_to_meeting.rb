class AddChannelToMeeting < ActiveRecord::Migration
  def change
    add_column :meetings, :channel, :integer
  end
end
