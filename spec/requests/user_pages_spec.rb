require 'spec_helper'
require 'support/utilities'
#
# Capybara.default_driver = :poltergeist#
# Capybara.app_host = "http://localhost:3000"

describe "User pages" do

  subject { page }

  describe "profile page" do
    let(:user) { create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup page" do
    before { visit '/signup' }

    it { should have_content('Sign up')}
    it { should have_title(full_title("Sign up")) }

  end

  describe "signup page" do

    before { visit '/signup'}

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "valid info" do
      before do
        fill_in "Name",         :with => "Example User"
        fill_in "Email",        :with => "Examaple@mail.com"
        fill_in "Password",     :with => "foobar"
        fill_in "Confirmation", :with => "foobar"

      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end

  end

end
