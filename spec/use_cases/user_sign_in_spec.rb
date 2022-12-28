require "rails_helper"

RSpec.describe Authorization::UserSignIn do
  let(:user_model) { double("User") }
  let(:use_case) { described_class.new(user_model: user_model) }

  let!(:user) { create(:user) }

  describe "#execute" do
    before do
      allow(user_model).to receive(:find_by).and_return(user)
    end

    context "when username and password are correct" do
      after do
        use_case.execute(username: user.username, password: user.password)
      end

      it "searches for user using username" do
        expect(user_model).to receive(:find_by).with(username: user.username)
      end

      it "creates new remember token" do
        expect(user).to receive(:generate_remember_token!).with(password: user.password)
      end

      it "returns user" do
        response = use_case.execute(username: user.username, password: user.password)
        expect(response).to eq(user)
      end
    end

    context "when user is not found" do
      let(:exception) { UserNotFoundException }

      before do
        allow(user_model).to receive(:find_by).and_return(nil)
      end

      it "raises user not found exception" do
        expect { use_case.execute(
          username: user.username, password: ""
        ) }.to raise_error(exception)
      end
    end

    context "when password is incorrect" do
      let(:exception) { WrongPasswordException }

      it "raises wrong password exception" do
        expect { use_case.execute(
          username: user.username, password: "wrong_password"
        ) }.to raise_error(exception)
      end
    end
  end
end