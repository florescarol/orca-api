require "rails_helper"

RSpec.describe Expense, type: :model do
  let(:category) { create(:category) }
  subject { create(:expense, category: category) }

  describe "relations" do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:amount) }
  end

  describe "#paid_in_installments?" do
    context "when installments number is equal to 1" do
      it "returns false" do
        expect(subject.paid_in_installments?).to eq(false)
      end
    end

    context "when installments number is bigger than 1" do
      before do
        subject.update!(installments_number: 3)
      end

      it "returns true" do
        expect(subject.paid_in_installments?).to eq(true)
      end
    end
  end

end