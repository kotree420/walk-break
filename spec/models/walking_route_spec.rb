require 'rails_helper'

RSpec.describe WalkingRoute, type: :model do
  let(:user) { create(:user) }
  let(:walking_route) { create(:walking_route, user: user) }
  let(:bookmark) { create(:bookmark, user_id: user.id, walking_route_id: walking_route.id) }

  before do
    sign_in user
  end

  it "すでに散歩ルートがブックマーク済みの場合、trueを返すこと" do
    bookmark
    expect(walking_route.bookmarked?(user)).to be_truthy
  end
end
