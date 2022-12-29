require "rails_helper"

RSpec.describe SettingsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:remember_token) { user.generate_remember_token!(password: user.password) }
  let!(:params) { { session_token: remember_token } }

  describe "GET index" do
    it "returns user payment methods and categories" do
      response = get :index, params: params
      data = JSON.parse(response.body)

      expect(data).to include("payment_methods", "grouped_categories")
    end
  end

end


