require "rails_helper"

RSpec.describe ExpensesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:remember_token) { user.generate_remember_token!(password: user.password) }
  let!(:params) { { session_token: remember_token } }

  describe "GET show" do
    context "when expense exists" do
      let(:expense) { create(:expense, user: user) }

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

  describe "PATCH update" do
    context "when expense does not exist" do
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

    context "when expense is not paid in installments" do
      let(:expense) { create(:expense, user: user) }
      let(:new_name) { "Nome novo" }
      let(:update_params) do
        {
          id: expense.id,
          expense: {
            name: new_name,
            amount: expense.amount,
            date: expense.date,
            payment_date: expense.payment_date,
            category_id: expense.category_id,
            payment_method_id: expense.payment_method_id,
            installments_number: expense.installments_number
          }
        }
      end

      it "updates the correct attribute" do
        expect { patch :update, params: params.merge(update_params) }
        .to change { expense.reload.name }.to(new_name)
      end
    end

    context "when adding installments to expense not paid in installments" do
      let!(:expense) { create(:expense, user: user) }
      let(:new_name) { "Nome novo" }
      let(:new_installments_number) { 3 }
      let(:update_params) do
        {
          id: expense.id,
          expense: {
            name: new_name,
            amount: expense.amount,
            date: expense.date,
            payment_date: expense.payment_date,
            category_id: expense.category_id,
            payment_method_id: expense.payment_method_id,
            installments_number: new_installments_number
          }
        }
      end

      it "updates the correct attribute" do
        expect { patch :update, params: params.merge(update_params) }
        .to change { expense.reload.name }.to(new_name)
        .and change { expense.installments_number }.to(new_installments_number)
      end

      it "creates new installments" do
        expect { patch :update, params: params.merge(update_params) }.to change(Expense, :count).by(2)
      end
    end

    context "when expense is paid in installments but installments number is not updated" do
      let(:expense) { create(:expense, user: user, installments_number: 2) }
      let(:installment) { expense.dup }
      let(:new_category_id) { create(:category).id }
      let(:update_params) do
        {
          id: expense.id,
          expense: {
            name: expense.name,
            amount: expense.amount,
            date: expense.date,
            payment_date: expense.payment_date,
            category_id: new_category_id,
            payment_method_id: expense.payment_method_id,
            installments_number: expense.installments_number
          }
        }
      end

      before do
        installment.update!(first_installment_id: expense.id)
      end

      it "updates original expense" do
        expect { patch :update, params: params.merge(update_params) }
        .to change { expense.reload.category_id }.to(new_category_id)
        .and not_change(expense, :installments_number)
      end

      it "updates installment" do
        expect { patch :update, params: params.merge(update_params) }
        .to change { installment.reload.category_id }.to(new_category_id)
        .and not_change(expense, :installments_number)
      end
    end

    context "when adding installments" do
      let(:expense) { create(:expense, user: user, installments_number: 2) }
      let(:installment) { expense.dup }
      let(:new_payment_method_id) { create(:payment_method).id }
      let(:new_installments_number) { 3 }
      let(:update_params) do
        {
          id: expense.id,
          expense: {
            name: expense.name,
            amount: expense.amount,
            date: expense.date,
            payment_date: expense.payment_date,
            category_id: expense.category_id,
            payment_method_id: new_payment_method_id,
            installments_number: new_installments_number
          }
        }
      end

      before do
        installment.update!(first_installment_id: expense.id)
      end

      it "updates original expense" do
        expect { patch :update, params: params.merge(update_params) }
        .to change { expense.reload.installments_number }.to(new_installments_number)
        .and change { expense.payment_method_id }.to(new_payment_method_id)
      end

      it "updates installment" do
        expect { patch :update, params: params.merge(update_params) }
        .to change { installment.reload.installments_number }.to(new_installments_number)
        .and change { installment.payment_method_id }.to(new_payment_method_id)
      end

      it "creates new installment" do
        expect { patch :update, params: params.merge(update_params) }.to change(Expense, :count).by(1)
      end
    end

    context "when removing installments" do
      let(:expense) { create(:expense, user: user, installments_number: 2) }
      let(:installment) { expense.dup }
      let(:new_installments_number) { 1 }
      let(:new_date) { "2022-10-22".to_date }
      let(:update_params) do
        {
          id: expense.id,
          expense: {
            name: expense.name,
            amount: expense.amount,
            date: new_date,
            payment_date: expense.payment_date,
            category_id: expense.category_id,
            payment_method_id: expense.payment_method_id,
            installments_number: new_installments_number
          }
        }
      end

      before do
        installment.update!(first_installment_id: expense.id)
      end

      it "updates original expense" do
        expect { patch :update, params: params.merge(update_params) }
        .to change { expense.reload.installments_number }.to(new_installments_number)
        .and change { expense.date }.to(new_date)
      end

      it "deletes installment" do
        expect { patch :update, params: params.merge(update_params) }.to change(Expense, :count).by(-1)
      end
    end
  end
end
