require 'rails_helper'

describe SleepSessionAggregator do
  let(:user) { create :user }
  let(:service) { described_class.new(user_id: user.id) }

  describe '#initialize' do
    context 'when only the user is provided' do
      it 'sets the attributes with the defaults' do
        expect(service.user).to eq user
        expect(service.page_size).to eq 500
        expect(service.page_number).to eq 1
      end
    end

    context 'when page size and page number are provided' do
      let(:params) { { user_id: user.id, page_number: 2, page_size: 50 } }
      let(:service) { described_class.new(**params) }

      it 'sets the correct attributes' do
        expect(service.user).to eq user
        expect(service.page_size).to eq 50
        expect(service.page_number).to eq 2
      end
    end

    context 'when user_id does not exit' do
      it 'raises an error' do
        expect { described_class.new(user_id: rand()) } .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#aggregate' do
    let(:sleep_session_1) { create :sleep_session, user: user }
    let(:sleep_session_2) { create :sleep_session, user: user }
    before do
      sleep_session_1
      Timecop.travel(2.days.after)
      sleep_session_2
    end
    it 'returns all sleep sessions of the user ordered by created_at' do
      results = service.aggregate

      expect(results.size).to eq(2)
      expect(results.map(&:id)).to eq([sleep_session_2.id, sleep_session_1.id])
    end
  end
end
