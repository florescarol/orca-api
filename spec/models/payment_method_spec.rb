require "rails_helper"

RSpec.describe PaymentMethod, type: :model do
  subject { create(:payment_method) }

  describe "relations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end

end