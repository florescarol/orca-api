require "rails_helper"

RSpec.describe CategoriesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:remember_token) { user.generate_remember_token!(password: user.password) }
  let!(:params) { { session_token: remember_token } }

  describe "GET index" do
    context "when category type is invalid" do
      it "returns bad request" do
        response = get :index, params: params
        expect(response.status).to eq(400)
      end
    end

    context "when category type is 'expense'" do
      let!(:expense_category_group) { create(:category_group, user: user) }
      let!(:category1) { create(:category, category_group: expense_category_group) }
      let!(:category2) { create(:category, category_group: expense_category_group) }
      let(:expected_data) do
        {
          "grouped_categories" => [
            {
              "id" => expense_category_group.id,
              "title" => expense_category_group.title,
              "color" => expense_category_group.color,
              "category_type" => expense_category_group.category_type,
              "categories" => [
                {
                  "id" => category1.id,
                  "name" => category1.name
                },
                {
                  "id" => category2.id,
                  "name" => category2.name
                }
              ]
            }
          ]
        }
      end

      it "returns user expenses categories grouped" do
        response = get :index, params: params.merge!({ type: "expense" })
        data = JSON.parse(response.body)

        expect(data).to eq(expected_data)
      end
    end

    context "when category type is 'earning'" do
      let!(:earning_category_group) { create(:category_group, :earning, user: user) }
      let!(:category1) { create(:category, category_group: earning_category_group) }
      let!(:category2) { create(:category, category_group: earning_category_group) }
      let(:expected_data) do
        {
          "grouped_categories" => [
            {
              "id" => earning_category_group.id,
              "title" => earning_category_group.title,
              "color" => earning_category_group.color,
              "category_type" => earning_category_group.category_type,
              "categories" => [
                {
                  "id" => category1.id,
                  "name" => category1.name
                },
                {
                  "id" => category2.id,
                  "name" => category2.name
                }
              ]
            }
          ]
        }
      end

      it "returns user earnings categories grouped" do
        response = get :index, params: params.merge!({ type: "earning" })
        data = JSON.parse(response.body)

        expect(data).to eq(expected_data)
      end
    end
  end

  describe "GET show" do
    context "when category exists" do
      let(:category) { create(:category) }

      it "returns category" do
        response = get :show, params: params.merge(id: category.id)
        category = JSON.parse(response.body)["category"]

        expect(category).to include("id", "name", "category_group_id")
      end
    end

    context "when category does not exists" do
      it "returns bad request" do
        response = get :show, params: params.merge(id: 1)
        expect(response.status).to eq(400)
      end
    end
  end

  describe "POST create" do
    context "when params are valid" do
      let(:category_group) { create(:category_group) }
      let(:category_params) do
        {
          category: {
            name: "Nome da categoria",
            category_group_id: category_group.id
          }
        }
      end

      it "creates new category" do
        expect { post :create, params: params.merge(category_params) }
        .to change(Category, :count).by(1)
      end
    end

    context "when params are incorrect" do
      let(:category_params) do
        {
          category: {
            name: "Nome da categoria"
          }
        }
      end

      it "does not creates category" do
        expect { post :create, params: params.merge(category_params) }
        .not_to change(Category, :count)
      end
    end
  end

  describe "PATCH update" do
    context "when category does not exists" do
      let(:invalid_params) do
        {
          id: 1,
          category: {
            name: ""
          }
        }
      end

      it "returns bad request" do
        response = patch :update, params: params.merge(invalid_params)
        expect(response.status).to eq(400)
      end
    end

    context "when update is successful" do
      let(:category) { create(:category) }
      let(:new_name) { "Novo nome" }
      let(:update_params) do
        {
          id: category.id,
          category: {
            name: new_name
          }
        }
      end

      it "updates the correct attribute" do
        expect { patch :update, params: params.merge(update_params)}
        .to change{ category.reload.name }.to(new_name)
      end
    end
  end
end
