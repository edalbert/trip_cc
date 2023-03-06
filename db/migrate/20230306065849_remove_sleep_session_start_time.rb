class RemoveSleepSessionStartTime < ActiveRecord::Migration[7.0]
  def change
    remove_column :sleep_sessions, :start_time
  end
end
