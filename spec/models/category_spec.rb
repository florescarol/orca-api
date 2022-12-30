require "rails_helper"

RSpec.describe Category, type: :model do
  subject { create(:category) }

  describe "relations" do
    it { is_expected.to belong_to(:category_group) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "#category_type" do
    it { is_expected.to delegate_method(:category_type).to(:category_group) }
  end

end