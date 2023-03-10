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
require 'faker'

FactoryBot.define do
  factory :sleep_session do
    association :user
  end
end
