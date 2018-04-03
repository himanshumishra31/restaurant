require 'rails_helper'

describe RegistrationsController do

  describe 'GET new' do
    before { get :new}
    it "is expected to render new form" do
      expect(response).to render_template(:new)
    end

    it "is expected to assign an instance variable" do
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe 'POST create' do
    before do
      password = Faker::Internet.password(8)
      post :create, params: { user: { name: Faker::Name.unique.name, password: password, password_confirmation: password, email: Faker::Internet.email }}
    end
    it "is expected to assign an instance variable" do
      expect(assigns(:user)).to be_instance_of(User)
    end

    context "when data passed is valid" do
      it "is expected to redirect to store index" do
        expect(response).to redirect_to(store_index_url)
      end

      it "is expected to show a flash message" do
        expect(flash[:success]).to eq('Please Confirm Your email')
      end
    end

    context "when data passed is invalid" do
      before { post :create, params: { user: { name: '', password: '', password_confirmation: '', email: '' } } }
      it "is expected to render new form" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET confirm_email' do
    context "when user if found with the id passed" do
      let(:user) { FactoryBot.create(:user, :user_not_confirmed, :customer) }
      it "is expected to show a flash message" do
        get :confirm_email, params: { id: user.confirmation_token }
        expect(flash[:success]).to eq("Your email has been confirmed. Please sign in to continue.")
      end

      it "is expected to redirect to login page" do
        get :confirm_email, params: { id: user.confirmation_token }
        expect(response).to redirect_to(login_url)
      end

      it "is expected to change confirmed state to true" do
        expect_any_instance_of(User).to receive(:activate_email).and_return(true)
        get :confirm_email, params: { id: user.confirmation_token }
      end
    end

    context "when user is not found with the id passed" do
      before { get :confirm_email, params: { id: 'abc' } }
      it "is expected to assign user variable to nil" do
        expect(assigns(:user)).to be(nil)
      end

      it "is expected to redirect to login url" do
        expect(response).to redirect_to(login_url)
      end

      it "is expected to show a flash message" do
        expect(flash[:danger]).to eq('Your email has been already confirmed. Please log in.')
      end
    end
  end
end
