require "rails_helper"

RSpec.describe UpdateExpenseWithInstallments do
  let(:expense_model) { double("Expense") }
  let(:use_case) { described_class.new(expense_model: expense_model) }

  let!(:expense) { create(:expense, installments_number: 2) }
  let!(:installment) { expense.dup }

  describe "#execute" do
    before do
      installment.update!(first_installment_id: expense.id)

      allow(expense_model).to receive(:find).and_return(expense)
    end

    context "when installments number is not updated" do
      let(:new_amount) { 300 }
      let(:new_payment_date) { "2022-03-10".to_date }
      let(:params) do
        {
          name: expense.name,
          amount: new_amount,
          installments_number: expense.installments_number,
          category_id: expense.category_id,
          payment_date: new_payment_date,
          date: expense.date,
          payment_method_id: expense.payment_method_id
        }
      end

      it "does not create or delete installments" do
        expect { use_case.execute(expense_id: expense.id, params: params) }.not_to change { Expense.count }
      end

      it "updates original expense" do
        expect { use_case.execute(expense_id: expense.id, params: params) }
        .to change { expense.amount }.to(new_amount)
        .and change { expense.payment_date }.to(new_payment_date)
        .and not_change(expense, :name)
        .and not_change(expense, :installments_number)
        .and not_change(expense, :date)
        .and not_change(expense, :category_id)
        .and not_change(expense, :payment_method_id)
      end

      it "updates installments" do
        expect { use_case.execute(expense_id: expense.id, params: params) }
        .to change { installment.reload.amount }.to(new_amount)
        .and change { installment.payment_date }.to(new_payment_date + 1.month)
        .and not_change(installment, :name)
        .and not_change(installment, :installments_number)
        .and not_change(installment, :date)
        .and not_change(installment, :category_id)
        .and not_change(installment, :payment_method_id)
      end
    end

    context "when trying to add more installments" do
      let(:new_name) { "Novo nome" }
      let(:new_installments_number) { 3 }
      let(:params) do
        {
          name: new_name,
          amount: expense.amount,
          installments_number: new_installments_number,
          category_id: expense.category_id,
          payment_date: expense.payment_date,
          date: expense.date,
          payment_method_id: expense.payment_method_id
        }
      end

      it "updates original expense" do
        expect { use_case.execute(expense_id: expense.id, params: params) }
        .to change { expense.installments_number }.to(new_installments_number)
        .and change { expense.name }.to(new_name)
        .and not_change(expense, :amount)
        .and not_change(expense, :payment_date)
        .and not_change(expense, :date)
        .and not_change(expense, :category_id)
        .and not_change(expense, :payment_method_id)
      end

      it "adds more installments" do
        expect { use_case.execute(expense_id: expense.id, params: params) }.to change(Expense, :count).by(1)
      end

      it "updates installments" do
        expect { use_case.execute(expense_id: expense.id, params: params) }
        .to change { installment.reload.installments_number }.to(new_installments_number)
        .and change { installment.name }.to(new_name)
        .and not_change(expense, :amount)
        .and not_change(expense, :payment_date)
        .and not_change(expense, :date)
        .and not_change(expense, :category_id)
        .and not_change(expense, :payment_method_id)
      end
    end

    context "when trying to remove installment" do
      let(:new_payment_method_id) { create(:payment_method).id }
      let(:new_installments_number) { 1 }
      let(:params) do
        {
          name: expense.name,
          amount: expense.amount,
          installments_number: new_installments_number,
          category_id: expense.category_id,
          payment_date: expense.payment_date,
          date: expense.date,
          payment_method_id: new_payment_method_id
        }
      end

      it "updates original expense" do
        expect { use_case.execute(expense_id: expense.id, params: params) }
        .to change { expense.installments_number }.to(new_installments_number)
        .and change { expense.payment_method_id }.to(new_payment_method_id)
        .and not_change(expense, :name)
        .and not_change(expense, :amount)
        .and not_change(expense, :payment_date)
        .and not_change(expense, :date)
        .and not_change(expense, :category_id)
      end

      it "removes last installment" do
        expect { use_case.execute(expense_id: expense.id, params: params) }.to change(Expense, :count).by(-1)
      end
    end
  end
end