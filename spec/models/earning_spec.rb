require "rails_helper"

RSpec.describe Earning, type: :model do
  let(:category) { create(:category) }
  subject { create(:earning, category: category) }

  describe "relations" do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:amount) }
  end

  describe "#category_name" do
    it "returns category name" do
      expect(subject.category_name).to eq(category.name)
    end
  end

end