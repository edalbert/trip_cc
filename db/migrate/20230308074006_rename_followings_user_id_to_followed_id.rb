class RenameFollowingsUserIdToFollowedId < ActiveRecord::Migration[7.0]
  def change
    rename_column :followings, :user_id, :followed_id
  end
end
