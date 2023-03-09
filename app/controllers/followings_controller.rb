class FollowingsController < ApplicationController
  def create
    Following.create(followings_params)
  end

  def delete
    Following.find_by(followings_params).delete
  end

  private

  def followings_params
    params.permit(:followed_id, :follower_id)
  end
end
