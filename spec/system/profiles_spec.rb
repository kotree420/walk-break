require 'rails_helper'

RSpec.describe "Profiles", type: :system do
  describe "プロフィール機能" do
    let(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:walking_route_created) { create(:walking_route, user: user) }
    let!(:walking_route_bookmarked) { create(:walking_route, user: other_user) }
    let!(:bookmark) do
      create(:bookmark, user_id: user.id, walking_route_id: walking_route_bookmarked.id)
    end

    before do
      sign_in user
    end

    context "サインイン中のユーザーのプロフィールを開く場合" do
      it "プロフィール編集機能でユーザー名と自己紹介を編集できること" do
        visit profile_path(user.id)

        expect(page).to have_selector ".show-profile-name", text: user.name
        expect(page).to have_selector ".show-profile-comment", text: user.comment
        expect(page).to have_link "プロフィール編集"
        expect(page).to have_link "設定"

        expect(page).to have_selector ".bookmarked-walking-route-name-0",
          text: walking_route_bookmarked.name
        expect(page).to have_selector ".created-walking-route-name-0",
          text: walking_route_created.name

        click_link "プロフィール編集"

        fill_in "ユーザー名", with: "new_name"
        fill_in "自己紹介", with: "new_comment"
        click_button "更新する"

        expect(page).to have_selector ".show-profile-name", text: "new_name"
        expect(page).to have_selector ".show-profile-comment", text: "new_comment"
      end
    end

    context "他のユーザーのプロフィールを開く場合" do
      it "プロフィール編集、設定ボタンが表示されていないこと" do
        visit profile_path(other_user.id)

        expect(page).to_not have_link "プロフィール編集"
        expect(page).to_not have_link "設定"
      end
    end
  end
end
