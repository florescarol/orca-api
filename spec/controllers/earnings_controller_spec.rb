require "rails_helper"

RSpec.describe EarningsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:remember_token) { user.generate_remember_token!(password: user.password) }
  let!(:params) { { session_token: remember_token } }

  describe "GET show" do
    context "when earning exists" do
      let(:earning) { create(:earning, user: user) }

      it "returns earning" do
        response = get :show, params: params.merge(id: earning.id)
        group = JSON.parse(response.body)["earning"]

        expect(group).to include("id", "name", "amount", "date", "category_id")
      end
    end

    context "when earning does not exists" do
      it "returns bad request" do
        response = get :show, params: params.merge(id: 1)

        expect(response.status).to eq(400)
      end
    end
  end

  describe "POST create" do
    let(:category) { create(:category) }

    context "when params are valid" do
      let(:earning_params) do
        {
          earning: {
            name: "Nome da entrada",
            amount: 100,
            date: Date.today,
            category_id: category.id,
          }
        }
      end

      it "creates new earning" do
        expect { post :create, params: params.merge(earning_params) }
        .to change(Earning, :count).by(1)
      end
    end

    context "when params are incorrect" do
      let(:earning_params) do
        {
          earning: {
            name: ""
          }
        }
      end

      it "does not creates earning" do
        expect { post :create, params: params.merge(earning_params) }
        .not_to change(Earning, :count)
      end
    end
  end

  describe "PATCH update" do
    context "when earning does not exist" do
      let(:invalid_params) do
        {
          id: 1
        }
      end

      it "returns bad request" do
        response = patch :update, params: params.merge(invalid_params)

        expect(response.status).to eq(400)
      end
    end

    context "when earning exists" do
      let(:earning) { create(:earning, user: user) }
      let(:new_name) { "Nome novo" }
      let(:update_params) do
        {
          id: earning.id,
          earning: {
            name: new_name,
            amount: earning.amount,
            date: earning.date,
            category_id: earning.category_id,
          }
        }
      end

      it "updates the correct attribute" do
        expect { patch :update, params: params.merge(update_params) }
        .to change { earning.reload.name }.to(new_name)
      end
    end

  end
end
