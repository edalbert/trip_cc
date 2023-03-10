class SleepSessionAggregator
  attr_reader :user, :page_number, :page_size, :from, :complete_only

  def initialize(user_id:, page_number: 1, page_size: 500, from: nil, complete_only: false)
    @user = User.find(user_id)
    @page_number = page_number
    @page_size = page_size
    @from = from.to_datetime if from.present?
    @complete_only = complete_only
  end

  # order sleep sessions by created_at
  def aggregate
    relation = user.sleep_sessions.order('created_at desc')
    relation = relation.where.not(end_time: nil) if complete_only # only get sleep sessions with values in end_time
    relation = relation.where('created_at >= ? ', from) if from.present?

    relation.paginate(page: page_number, per_page: page_size)
  end
end
