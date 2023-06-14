require 'rails_helper'

RSpec.describe "WalkingRoutes", type: :system do

describe "散歩ルート作成機能", js: true do
  it "散歩ルート作成画面にてルート作成を実行すると、詳細表示ページに遷移して作成した情報が表示されること", js: true do
    visit new_walking_route_path

    # マップが表示されているか
    expect(page).to have_css ".gm-style"

    fill_in '散歩ルート名:', with: '散歩ルート1'
    fill_in 'ひとことコメント:', with: '散歩コメント1'
    fill_in '出発地:', with: '東京駅'
    click_button '経由地を追加'
    click_button '経由地を追加'
    fill_in 'waypoint1', with: '有楽町駅'
    fill_in 'waypoint2', with: '日比谷駅'
    fill_in '到着地:', with: '銀座駅'

    click_button 'ルート出力'

    # マップ上に地点マーカーが表示されているか
    expect(page).to have_css "#gmimap0"
    expect(page).to have_css "#gmimap1"
    expect(page).to have_css "#gmimap2"
    expect(page).to have_css "#gmimap3"

    # マップ上にルートポリラインが表示されているか
    within '.gm-style' do
      expect(find("img[src='https://maps.gstatic.com/mapfiles/undo_poly.png']", visible: false)).to be_truthy
    end

    # 経由地を削除するとマーカーが一つ消え、class名に番号が振りなおされる
    click_button '経由地を削除'
    expect(page).to_not have_css "#gmimap0"
    expect(page).to_not have_css "#gmimap1"
    expect(page).to_not have_css "#gmimap2"
    expect(page).to_not have_css "#gmimap3"
    expect(page).to have_css "#gmimap4"
    expect(page).to have_css "#gmimap5"
    expect(page).to have_css "#gmimap6"

    expect(page).to have_field '距離/km', with: '1.163'
    expect(page).to have_field '時間/分', with: '15'
    expect(page).to have_field '出発地:', with: '日本、〒100-0005 東京都千代田区丸の内１丁目９−１'
    expect(page).to have_field 'waypoint1', with: '日本、〒100-0006 東京都千代田区有楽町２丁目９ 有楽町駅'
    expect(page).to have_field '到着地:', with: '日本、〒104-0061 東京都中央区銀座４丁目１−２ 銀座駅'

    click_button 'ルート作成'

    # showビューに情報が表示されていることを確認する
    expect(page).to have_content 'ルート作成が完了しました'

    within ".gm-style" do
      expect(find("img[src='https://maps.gstatic.com/mapfiles/undo_poly.png']", visible: false)).to be_truthy
    end
  end
end
end
