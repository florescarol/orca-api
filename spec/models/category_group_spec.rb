require "rails_helper"

RSpec.describe CategoryGroup, type: :model do
  subject { create(:category_group) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }

    it { is_expected.to validate_inclusion_of(:category_type).in_array(CATEGORY_TYPES::ALL) }
  end

end