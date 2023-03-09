require 'rails_helper'

describe FollowingsController do
  let(:user) { create :user }
  let(:follower) { create :user }
  let(:params) { { follower_id: follower.id, followed_id: user.id } }

  describe '#create' do
    let(:request) { -> { post :create, params: params } }

    it 'creates a new following' do
      expect { request.call }.to change(Following, :count).by(1)
    end

    it 'saves the correct association' do
      request.call
      expect(user.followers).to include(follower)
      expect(follower.followed).to include(user)
    end

    context 'when a user already follows the other user' do
      before { request.call }

      it 'does not allow following the same person twice' do
        expect { request.call }.to raise_error ActiveRecord::RecordNotUnique
      end
    end
  end

  describe '#delete' do
    let(:request) { -> { delete :delete, params: params }}

    before { user.followers << follower }

    it 'deletes a following' do
      expect { request.call }.to change(Following, :count).by(-1)
    end

    context 'when trying to delete a following that does not exist' do
      let(:another_user) { create :user }
      let(:params) { { followed_id: user.id, follower_id: another_user.id } }

      it 'raises an error' do
        expect { request.call }.to raise_error(StandardError)
      end
    end
  end
end
