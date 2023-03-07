# == Schema Information
#
# Table name: sleep_sessions
#
#  id         :integer          not null, primary key
#  end_time   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  users_id   :integer
#
require "test_helper"

class SleepSessionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
