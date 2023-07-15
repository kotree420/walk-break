require 'rails_helper'

RSpec.describe WalkingRoute, type: :model do
  let(:user) { create(:user) }
  let!(:withdrawal_user) { create(:user) }
  let(:walking_route) { create(:walking_route, user: user) }
  let!(:bookmark) { create(:bookmark, user_id: user.id, walking_route_id: walking_route.id) }
  let!(:bookmark_not_eligible) { create(:bookmark, user_id: withdrawal_user.id, walking_route_id: walking_route.id) }

  before do
    sign_in user
  end

  it "退会済みのユーザーを除くブックマーク数が返されること" do
    withdrawal_user.update(is_deleted: true)
    expect(walking_route.bookmarks_count).to eq 1
  end

  it "すでに散歩ルートがブックマーク済みの場合、trueを返すこと" do
    expect(walking_route.bookmarked?(user)).to be_truthy
  end
end
