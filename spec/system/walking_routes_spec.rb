require 'rails_helper'

RSpec.describe "WalkingRoutes", type: :system do
  describe "散歩ルート作成機能", js: true do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it "散歩ルート作成画面にてルート作成を実行すると、詳細表示ページに遷移して作成した情報が表示されること", js: true do
      visit new_walking_route_path

      # マップが表示されているか
      expect(page).to have_css ".gm-style"

      fill_in "散歩ルート名:", with: "散歩ルート1"
      fill_in "ひとことコメント:", with: "散歩コメント1"
      fill_in "出発地:", with: "日本、〒100-0005 東京都千代田区丸の内１丁目９ JR 東京駅"
      click_button "経由地を追加"
      click_button "経由地を追加"
      fill_in "waypoint1", with: "日本、〒100-0006 東京都千代田区有楽町２丁目９ 有楽町駅"
      fill_in "waypoint2", with: "日本、〒100-0006 東京都千代田区有楽町１丁目 日比谷駅"
      fill_in "到着地:", with: "日本、〒104-0061 東京都中央区銀座４丁目１−２ 銀座駅"

      click_button "ルート出力"

      # マップ上に地点マーカーが表示されているか
      expect(page).to have_css "#gmimap0"
      expect(page).to have_css "#gmimap1"
      expect(page).to have_css "#gmimap2"
      expect(page).to have_css "#gmimap3"

      # マップ上にルートポリラインが表示されているか
      within ".gm-style" do
        expect(find("img[src='https://maps.gstatic.com/mapfiles/undo_poly.png']", visible: false)).
          to be_truthy
      end

      # 経由地を削除するとマーカーが一つ消え、id名が振り直される
      click_button "経由地を削除"
      expect(page).to_not have_css "#gmimap0"
      expect(page).to_not have_css "#gmimap1"
      expect(page).to_not have_css "#gmimap2"
      expect(page).to_not have_css "#gmimap3"
      expect(page).to have_css "#gmimap4"
      expect(page).to have_css "#gmimap5"
      expect(page).to have_css "#gmimap6"

      expect(page).to have_field "距離/km", with: "1.113"
      expect(page).to have_field "時間/分", with: "14"
      expect(page).to have_field "出発地:", with: "日本、〒100-0005 東京都千代田区丸の内１丁目９ JR 東京駅"
      expect(page).to have_field "waypoint1", with: "日本、〒100-0006 東京都千代田区有楽町２丁目９ 有楽町駅"
      expect(page).to have_field "到着地:", with: "日本、〒104-0061 東京都中央区銀座４丁目１−２ 銀座駅"

      click_button "ルート作成"

      # リダイレクト後のshowビューに情報が表示されていることを確認する
      expect(current_path).to eq walking_route_path(WalkingRoute.first.id)

      expect(page).to have_content "ルート作成が完了しました"

      within ".gm-style" do
        expect(find("img[src='https://maps.gstatic.com/mapfiles/undo_poly.png']", visible: false)).
          to be_truthy
      end

      expect(page).to have_selector "#created-at-value", text: WalkingRoute.first.created_at.
        strftime("%Y/%m/%d %H:%M:%S")
      expect(page).to have_selector "#show-walking-route-name", text: WalkingRoute.first.name
      expect(page).to have_selector "#show-walking-route-comment", text: WalkingRoute.first.comment
      expect(page).to have_selector "#show-total-distance", text: "#{WalkingRoute.first.distance}km"
      expect(page).to have_selector "#show-total-duration", text: "#{WalkingRoute.first.duration}分"
      expect(page).to have_selector "#show-start-address", text: WalkingRoute.first.start_address
      expect(page).to have_selector "#show-end-address", text: WalkingRoute.first.end_address
    end

    it "経由地は10を越える数を追加できないこと", js: true do
      visit new_walking_route_path

      11.times do
        click_button "経由地を追加"
      end

      expect(all(".waypoint").count).to eq 10
    end
  end
end
