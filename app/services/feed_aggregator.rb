class FeedAggregator
  attr_reader :user, :from

  def initialize(user_id:, from: nil)
    @user = User.find user_id
    @from = from.present? ? from : 7.days.ago.beginning_of_day
  end

  def aggregate
    user.followed.each_with_object({}) do |friend, hash|
       service = SleepSessionAggregator.new(user_id: friend.id, from: from, complete_only: true)

      hash[friend.id] = {
        user: user_summary(friend),
        sleep_sessions: sleep_session_summary(service.aggregate.sort_by(&:duration_in_minutes).reverse)
      }
    end
  end

  private

  def user_summary(friend)
    {
      id: friend.id,
      name: friend.name,
    }
  end

  def sleep_session_summary(sessions)
    sessions.map do |session|
      {
        id: session.id,
        start_time: session.start_time,
        end_time: session.end_time,
        duration: session.humanized_duration,
        created_at: session.created_at,
        updated_at: session.updated_at
      }
    end
  end
end
