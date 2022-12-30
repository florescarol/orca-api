require "rails_helper"

RSpec.describe ExpensesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:remember_token) { user.generate_remember_token!(password: user.password) }
  let!(:params) { { session_token: remember_token } }

  describe "GET show" do
    context "when expense exists" do
      let(:expense) { create(:expense) }

      it "returns expense" do
        response = get :show, params: params.merge(id: expense.id)
        group = JSON.parse(response.body)["expense"]

        expect(group).to include("id", "name", "amount",
          "first_installment_id", "installments_number",
          "date", "payment_date", "category_id",
          "payment_method_id"
        )
      end
    end

    context "when expense does not exists" do
      it "returns bad request" do
        response = get :show, params: params.merge(id: 1)

        expect(response.status).to eq(400)
      end
    end
  end

  describe "POST create" do
    let(:category) { create(:category) }
    let(:payment_method) { create(:payment_method) }

    context "when params are valid" do
      let(:expense_params) do
        {
          expense: {
            name: "Nome da despesa",
            amount: 100,
            date: Date.today,
            payment_date: Date.today+5,
            category_id: category.id,
            payment_method_id: payment_method.id,
            installments_number: 1
          }
        }
      end

      it "creates new expense" do
        expect { post :create, params: params.merge(expense_params) }
        .to change(Expense, :count).by(1)
      end
    end

    context "when expense is paid in installments" do
      let(:expense_params) do
        {
          expense: {
            name: "Despesa parcelada",
            amount: 100,
            date: Date.today,
            payment_date: Date.today+5,
            category_id: category.id,
            payment_method_id: payment_method.id,
            installments_number: 3
          }
        }
      end

      it "creates new expense and installments" do
        expect { post :create, params: params.merge(expense_params) }
        .to change(Expense, :count).by(3)
      end
    end

    context "when params are incorrect" do
      let(:expense_params) do
        {
          expense: {
            name: ""
          }
        }
      end

      it "does not creates expense" do
        expect { post :create, params: params.merge(expense_params) }
        .not_to change(Expense, :count)
      end
    end
  end
end
