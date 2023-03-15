class SleepSessionsController < ApplicationController
  def create
    user = User.find(create_sleep_session_params[:user_id])
    user.sleep_sessions.create(start_time: Time.now)

    sessions =
      SleepSessionAggregator.new(user_id: create_sleep_session_params[:user_id]).aggregate

    render json: sessions
  end

  def update
    user = User.find(update_sleep_session_params[:user_id])

    sleep_session = user
      .sleep_sessions.find_by!(id: update_sleep_session_params[:sleep_session_id])

    raise 'Sleep session is already clocked out.' if sleep_session.end_time.present?

    sleep_session.end_time = Time.now
    sleep_session.save

    render json: sleep_session
  end

  def feed
    service = FeedAggregator.new(user_id: feed_params[:user_id], from: feed_params[:from])

    render json: service.aggregate
  end

  private

  def create_sleep_session_params
    params.permit(:user_id, :page_number, :page_size)
  end

  def feed_params
    params.permit(:user_id, :from)
  end

  def update_sleep_session_params
    params.permit(:user_id, :sleep_session_id)
  end
end
