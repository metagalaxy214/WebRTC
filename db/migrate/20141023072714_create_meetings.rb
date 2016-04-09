class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|

      t.integer   :user_id

      t.string    :pusher_channel      
      t.text      :tokbox_session_id
      t.text      :tokbox_token

      t.boolean   :is_expired
      t.timestamps
      
    end
  end
end
