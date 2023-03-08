# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  has_many :sleep_sessions

  has_many :followings_as_follower, foreign_key: :followed_id, class_name: 'Following'
  has_many :followings_as_followed, foreign_key: :follower_id, class_name: 'Following'

  has_many :followers, through: :followings_as_follower
  has_many :followed, through: :followings_as_followed
end
