# == Schema Information
#
# Table name: sleep_sessions
#
#  id         :integer          not null, primary key
#  start_time :datetime
#  end_time   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SleepSession < ApplicationRecord
end
