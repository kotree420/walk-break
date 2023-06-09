require 'rails_helper'

RSpec.describe "WalkingRoutes", type: :request do
  let(:walking_route) { create(:walking_route) }

  describe "GET /walking_routes" do
    before do
      get walking_routes_path
    end

    it "ステータスコードに 200: OK が返されること" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /walking_routes/:id" do
    before do
      get walking_route_path(walking_route.id)
    end

    it "ステータスコードに 200: OK が返されること" do
      expect(response).to have_http_status(200)
    end
    it "作成日時が表示されていること" do
      expect(response.body).to include(walking_route.created_at.strftime('%Y/%m/%d %H:%M:%S'))
    end
    it "散歩ルート名が表示されていること" do
      expect(response.body).to include(walking_route.name)
    end
    it "コメントが表示されていること" do
      expect(response.body).to include(walking_route.comment)
    end
    it "距離が表示されていること" do
      expect(response.body).to include(walking_route.distance.to_s)
    end
    it "時間が表示されていること" do
      expect(response.body).to include(walking_route.duration.to_s)
    end
    it "出発地が表示されていること" do
      expect(response.body).to include(walking_route.start_address)
    end
    it "到着地が表示されていること" do
      expect(response.body).to include(walking_route.end_address)
    end
    it "散歩ルートを表すパスが返されていること" do
      expect(response.body).to include(walking_route.encorded_path)
    end
  end

  describe "GET /walking_routes/new" do
    before do
      get new_walking_route_path
    end

    it "ステータスコードに 200: OK が返されること" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /walking_routes" do
    context "全てのカラムが埋められていてリクエストが成功する場合" do
      let(:request) do
        post walking_routes_path, params: { walking_route: attributes_for(:walking_route) }
      end

      it "showアクションにリダイレクトされること" do
        request
        expect(response).to redirect_to(walking_route_path(WalkingRoute.first.id))
      end

      it "送信した散歩ルートが保存されていること" do
        expect { request }.to change(WalkingRoute, :count).by(1)
      end
    end

    context "カラムに不足がありリクエストが失敗する場合" do
      let(:request) do
        post walking_routes_path, params: { walking_route: { name: "散歩ルート1" } }
      end

      before do
        request
      end

      it "newアクションにリダイレクトされること" do
        expect(response).to redirect_to(new_walking_route_path)
      end
      it "リダイレクト先のnewでエラーメッセージが表示されること" do
        get new_walking_route_path
        flash.each do |key, values|
          values.each do |value|
            expect(response.body).to include(value)
          end
        end
      end
      it "リダイレクト後も元々入力されていたパラメータ値は保持されていること" do
        get new_walking_route_path
        session[:walking_route].each_value do |value|
          if value.present?
            expect(response.body).to include(value)
          end
        end
      end
    end
  end
end
