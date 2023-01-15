require "rails_helper"

RSpec.describe CreateExpenseInstallments do
  let(:expense_model) { double("Expense") }
  let(:use_case) { described_class.new(expense_model: expense_model) }

  let!(:expense) { create(:expense) }

  describe "#execute" do
    before do
      allow(expense_model).to receive(:find).and_return(expense)
    end

    context "when installments number is 1" do
      it "does not create new expenses" do
        expect(expense).not_to receive(:dup)

        use_case.execute(expense_id: expense.id)
      end
    end

    context "when installments number is bigger than 1" do
      before do
        expense.update!(installments_number: 4)

        allow(expense).to receive(:dup).and_return(expense)
      end

      it "creates (installments number - 1) expenses" do
        expect(expense).to receive(:dup).exactly(3).times

        use_case.execute(expense_id: expense.id)
      end
    end
  end
end