class SleepSessionAggregator
  attr_reader :user, :page_number, :page_size, :from

  def initialize(user_id:, page_number: 1, page_size: 500, from: nil)
    @user = User.find(user_id)
    @page_number = page_number
    @page_size = page_size
    @from = from.to_datetime if from.present?
  end

  # order sleep sessions by created_at
  def aggregate
    relation = user.sleep_sessions.order('created_at desc')

    relation = relation.where('created_at >= ? ', from) if from.present?
    relation.paginate(page: page_number, per_page: page_size)
  end
end
