require 'rails_helper'

describe SleepSessionsController do
  let(:user) { create :user }

  before { Timecop.freeze }
  after(:all) { Timecop.return }

  describe '#create' do
    let(:request) { -> { post :create, params: params } }
    let(:params) { { user_id: user.id } }
    let(:now) { Time.now.utc.as_json }
    it 'creates a new sleep session for the user' do
      expect { request.call }.to change(SleepSession, :count).by(1)
    end

    it 'lets user clock in with the current time' do
      request.call
      expect(parsed_response.first['start_time']).to eq now
    end

    context 'when user has multiple sleep sessions' do
      before do
        user.sleep_sessions.create(start_time: Time.now)
        Timecop.travel(2.days.after)
        user.sleep_sessions.create(start_time: Time.now)
      end

      it 'returns all of the sleep sessions' do
        request.call
        expect(parsed_response.size).to eq(3)
      end
    end

    context 'when user has more than 500 sleep sessions' do
      before do
        for _i in 0...502 do
          user.sleep_sessions.create
        end
      end

      it 'returns only the first 500 sleep sessions because of pagination' do
        request.call
        expect(parsed_response.size).to eq(500)
      end
    end
  end
end
