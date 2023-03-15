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
        create :sleep_session, user: user, start_time: Time.now
        Timecop.travel(2.days.after)
        create :sleep_session, user: user, start_time: Time.now
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
  describe '#update' do
    let(:request) { -> { patch :update, params: params } }
    let(:params) { { user_id: user.id, sleep_session_id: sleep_session.id } }
    let(:sleep_session) { create :sleep_session, user: user, end_time: nil }

    it 'updates a sleep_session`s` end_time with a value' do
      request.call
      expect(sleep_session.reload.end_time).to_not be_nil# change(sleep_session, :end_time)
    end

    context 'when the sleep session does not belong to the user' do
      let(:another_user) { create :user }
      let(:sleep_session) { create :sleep_session, user: another_user, end_time: nil }

      it 'wont find the sleep session' do
        expect { request.call }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the sleep session is already clocked out' do
      let(:sleep_session) { create :sleep_session, user: user }

      it 'raises an error' do
        expect { request.call }.to raise_error('Sleep session is already clocked out.')
      end
    end
  end

  describe '#feed' do
    let(:request) { -> { get :feed, params: params } }

    let(:params) { { user_id: user.id } }

    context 'when a user does not follow anyone' do
      it 'returns an empty hash' do
        request.call
        expect(parsed_response).to eq({})
      end
    end

    context 'when a user follows other users' do
      let(:params) { { user_id: user.id, from: 2.days.ago }}
      let(:another_user) { create :user }
      let(:sleep_session) { create :sleep_session, user: another_user }
      before do
        user.followed << another_user
        Timecop.travel(3.days.ago)
        create_list :sleep_session, 3, user_id: another_user.id

        Timecop.return
        sleep_session
      end

      it 'returns only sleep sessions from a certain point in time' do
        request.call

        result = parsed_response[another_user.id.to_s]['sleep_sessions']
        expect(result.size).to eq(1)

        ids = result.map { |x| x['id'] }
        expect(ids).to eq([sleep_session.id])
      end
    end
  end
end
