
class SleepSessionAggregator
  attr_reader :user, :page_number, :page_size

  def initialize(user_id:, page_number: 1, page_size: 500)
    @user = User.find(user_id)
    @page_number = page_number
    @page_size = page_size
  end

  # order sleep sessions by created_at
  def aggregate
    user.sleep_sessions.order('created_at desc').paginate(page: page_number, per_page: page_size)
  end
end
