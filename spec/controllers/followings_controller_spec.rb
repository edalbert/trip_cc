require 'rails_helper'

describe FollowingsController do
  let(:user) { create :user }
  let(:follower) { create :user }
  let(:params) { { follower_id: follower.id, followed_id: user.id } }
  let(:request) { -> { post :create, params: params } }

  it 'creates a new following' do
    expect { request.call }.to change(Following, :count).by(1)
  end

  it 'saves the correct association' do
    request.call
    expect(user.followers).to include(follower)
    expect(follower.followed).to include(user)
  end

  context 'when a user already follows another user' do
    before { request.call }

    it 'does not allow following the same person twice' do
      expect { request.call }.to raise_error ActiveRecord::RecordNotUnique
    end
  end
end
