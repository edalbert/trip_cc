class AddStartTimeToSleepSessions < ActiveRecord::Migration[7.0]
  def change
    add_column :sleep_sessions, :start_time, :datetime
  end
end
