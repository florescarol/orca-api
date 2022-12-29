require "rails_helper"

RSpec.describe CategoryGroupsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:remember_token) { user.generate_remember_token!(password: user.password) }
  let!(:params) { { session_token: remember_token } }

  describe "GET types" do
    it "returns possible category types" do
      response = get :types, params: params

      expect(JSON.parse(response.body)).to include("types")
    end
  end

  describe "GET show" do
    context "when category group exists" do
      let(:category_group) { create(:category_group) }

      it "returns category group" do
        response = get :show, params: params.merge(id: category_group.id)
        group = JSON.parse(response.body)["category_group"]

        expect(group).to include("id", "title", "category_type", "color")
      end
    end

    context "when category group does not exists" do
      it "returns bad request" do
        response = get :show, params: params.merge(id: 1)
        expect(response.status).to eq(400)
      end
    end
  end

  describe "POST create" do
    context "when params are valid" do
      let(:category_group_params) do
        { category_group: {
          title: "Salário",
          category_type: "earning",
          color: ""
        }}
      end

      it "creates new category group" do
        expect { post :create, params: params.merge(category_group_params) }
        .to change(CategoryGroup, :count).by(1)
      end
    end

    context "when params are incorrect" do
      let(:category_group_params) do
        { category_group: {
          category_type: "earning",
          color: ""
        }}
      end

      it "does not creates category group" do
        expect { post :create, params: params.merge(category_group_params) }
        .not_to change(CategoryGroup, :count)
      end
    end
  end

  describe "PATCH update" do
    context "when category group does not exists" do
      let(:invalid_params) do
        {
          id: 1,
          category_group: {
            title: ""
          }
        }
      end

      it "returns bad request" do
        response = patch :update, params: params.merge(invalid_params)
        expect(response.status).to eq(400)
      end
    end

    context "when update is successful" do
      let(:category_group) { create(:category_group) }
      let(:new_title) { "Novo nome" }
      let(:update_params) do
        {
          id: category_group.id,
          category_group: {
            title: new_title
          }
        }
      end

      it "updates the correct attribute" do
        expect { patch :update, params: params.merge(update_params)}
        .to change{ category_group.reload.title }.to(new_title)
      end
    end
  end
end


