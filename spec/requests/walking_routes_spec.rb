require 'rails_helper'

RSpec.describe "WalkingRoutes", type: :request do
  let(:walking_route) { create(:walking_route) }

  describe "GET /walking_routes" do
    it "ステータスコードに 200: OK が返されること"
  end

  describe "GET /walking_routes/:id" do
    it "ステータスコードに 200: OK が返されること"
    it "作成日時が表示されていること"
    it "散歩ルート名が表示されていること"
    it "コメントが表示されていること"
    it "距離が表示されていること"
    it "時間が表示されていること"
    it "出発地が表示されていること"
    it "到着地が表示されていること"
    it "散歩ルートを表すパスが返されていること"
  end

  describe "GET /walking_routes/new" do
    it "ステータスコードに 200: OK が返されること"

    context "createアクションからリダイレクトされてきた場合" do
      it "送信した値が保持されていること"
    end
  end

  describe "POST /walking_routes" do
    it "ステータスコードに 200: OK が返されること"
    it "全てのカラムが埋まっていればリクエストが成功すること"
    it "埋められていないカラムがあるとリクエストが失敗すること"

    context "リクエストが成功した場合" do
      it "showアクションにリダイレクトすること"
      it "散歩ルートが１件保存されていること"
    end

    context "リクエストが失敗した場合" do
      it "送信した値を保持しながらnewにリダイレクトすること"
      it "エラーメッセージがnewビューに表示されること"
    end
  end
end
