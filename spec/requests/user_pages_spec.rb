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
      describe "posle zaprosa na registraciu" do
        before { click_button submit }
        it {should have_title('Sign up')}
        it {should have_content("The form contains 5 errors")}
        it {should have_content( "Name can't be blank
* Email can't be blank
* Email is invalid
* Password can't be blank
* Password is too short (minimum is 6 characters)")}
      end
      describe "posle zaprosa na registraciu: diffrent pass" do
        before do
          fill_in "Name",         :with => "Example User"
          fill_in "Email",        :with => "Examaple@mail.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "barfoo"
          click_button submit
        end
        it {should have_title('Sign up')}
        it { should have_content("* Password confirmation doesn't match Password")}
      end
      describe "posle zaprosa na registraciu: without pass" do
        before do
          fill_in "Name",         :with => "Example User"
          fill_in "Email",        :with => "Examaple@mail.com"

          click_button submit
        end
        it {should have_title('Sign up')}
        it { should have_content('The form contains 2 errors')}
        it { should have_content("Password can't be blank")}
        it { should have_content('Password is too short (minimum is 6 characters)')}
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

      describe "posle zaprosa na registraciu" do
        let(:user) { create(:user) }
        before { click_button submit }
        it { should have_content('Welcome to the Sample app') }
        it { should have_title(user.name)}
      end

      describe "posle soxranenia user'a" do
        let(:user) { User.find_by(email: "examaple@mail.com") }
        before { click_button submit }
        it { should have_selector('div.alert.alert-success', text:'Welcome') }
        it { should have_title(user.name)}
      end

    end

  end

end
