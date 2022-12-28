require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  let!(:user) { create(:user) }

  describe "POST create" do
    context "when username and password are correct" do
      let!(:response) { post :create, params: params }
      let(:params) { { username: user.username, password: user.password } }

      it "returns status 200" do
        expect(response.status).to eq(200)
      end

      it "returns message and remember token" do
        expect(JSON.parse(response.body)).to include("message", "remember_token")
      end
    end

    context "when user is not found" do
      let!(:response) { post :create, params: params }
      let(:params) { { username: "wrong_username", password: user.password } }

      it "returns status 200" do
        expect(response.status).to eq(401)
      end

      it "returns message and remember token" do
        expect(JSON.parse(response.body)).to include("message")
      end
    end

    context "when password is incorrect" do
      let!(:response) { post :create, params: params }
      let(:params) { { username: user.username, password: "wrong_password" } }

      it "returns status 200" do
        expect(response.status).to eq(401)
      end

      it "returns message and remember token" do
        expect(JSON.parse(response.body)).to include("message")
      end
    end

  end
end


