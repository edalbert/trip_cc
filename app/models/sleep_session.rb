# == Schema Information
#
# Table name: sleep_sessions
#
#  id         :integer          not null, primary key
#  end_time   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  start_time :datetime
#
class SleepSession < ApplicationRecord
  self.per_page = 500

  belongs_to :user
end
