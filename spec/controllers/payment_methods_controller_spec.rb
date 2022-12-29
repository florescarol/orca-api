require "rails_helper"

RSpec.describe PaymentMethodsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:remember_token) { user.generate_remember_token!(password: user.password) }
  let!(:params) { { session_token: remember_token } }

  describe "GET show" do
    context "when payment_method exists" do
      let(:payment_method) { create(:payment_method) }

      it "returns payment_method" do
        response = get :show, params: params.merge(id: payment_method.id)
        payment_method = JSON.parse(response.body)["payment_method"]

        expect(payment_method).to include("id", "name")
      end
    end

    context "when payment_method does not exists" do
      it "returns bad request" do
        response = get :show, params: params.merge(id: 1)
        expect(response.status).to eq(400)
      end
    end
  end

  describe "POST create" do
    context "when params are valid" do
      let(:payment_method_group) { create(:payment_method_group) }
      let(:payment_method_params) do
        {
          payment_method: {
            name: "Nome do cartão",
          }
        }
      end

      it "creates new payment_method" do
        expect { post :create, params: params.merge(payment_method_params) }
        .to change(PaymentMethod, :count).by(1)
      end
    end

    context "when params are incorrect" do
      it "does not creates payment_method" do
        expect { post :create, params: params }
        .not_to change(PaymentMethod, :count)
      end
    end
  end

  describe "PATCH update" do
    context "when payment_method does not exists" do
      let(:invalid_params) do
        {
          id: 1,
          payment_method: {
            name: ""
          }
        }
      end

      it "returns bad request" do
        response = patch :update, params: params.merge(invalid_params)
        expect(response.status).to eq(400)
      end
    end

    context "when update is successful" do
      let(:payment_method) { create(:payment_method) }
      let(:new_name) { "Novo nome" }
      let(:update_params) do
        {
          id: payment_method.id,
          payment_method: {
            name: new_name
          }
        }
      end

      it "updates the correct attribute" do
        expect { patch :update, params: params.merge(update_params)}
        .to change{ payment_method.reload.name }.to(new_name)
      end
    end
  end
end


