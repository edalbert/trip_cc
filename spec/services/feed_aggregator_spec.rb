require 'rails_helper'

describe FeedAggregator do
  let(:service) { described_class.new(**params) }

  let(:user) { create :user }
  let(:followed_user) { create :user }

  before { user.followed << followed_user }

  describe '#sleep_sessions' do
    let(:sleep_session_from_beyond_7_days) do
      create :sleep_session, user_id: followed_user.id
    end
    let(:params) { { user_id: user.id } }
    before do
      Timecop.travel(8.days.ago)
      sleep_session_from_beyond_7_days
      Timecop.travel(3.days.after)
      create_list :sleep_session, 3, user_id: followed_user.id
      Timecop.return
    end

    context 'when passing just the user_id' do
      it 'returns only sleep sessions from within 7 days' do
        sessions = service.aggregate

        expect(sessions.keys).to eq([followed_user.id])
        expect(sessions[followed_user.id][:sleep_sessions].size).to eq(3)
      end
    end

    context 'when passing a from filter' do
      let(:params) { { user_id: user.id, from: 10.days.ago } }

      it 'returns all sleep sessions' do
        sessions = service.aggregate

        expect(sessions[followed_user.id][:sleep_sessions].size).to eq(4)
      end
    end
  end
end
