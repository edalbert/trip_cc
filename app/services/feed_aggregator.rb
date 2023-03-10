class FeedAggregator
  attr_reader :user, :from

  def initialize(user_id:, from: nil)
    @user = User.find user_id
    @from = from.present? ? from : 7.days.ago.beginning_of_day
  end

  def aggregate
    user.followed.each_with_object({}) do |friend, hash|
       service = SleepSessionAggregator.new(user_id: friend.id, from: from)

      hash[friend.id] = {
        user: user_summary(friend),
        sleep_sessions: service.aggregate,
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
end
