class RenameSleepSessionUsersIdToUserId < ActiveRecord::Migration[7.0]
  def change
    rename_column :sleep_sessions, :users_id, :user_id
  end
end
