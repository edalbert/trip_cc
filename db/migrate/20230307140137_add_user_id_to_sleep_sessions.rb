class AddUserIdToSleepSessions < ActiveRecord::Migration[7.0]
  def change
    add_reference :sleep_sessions, :users, index: true
  end
end
