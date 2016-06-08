require 'spec_helper'
require_relative '../support/utilities'
#
Capybara.default_driver = :poltergeist#
Capybara.app_host = "http://localhost:3000"

describe "User pages" do

  subject { page }

  describe "index" do
    let(:user) {FactoryGirl.create(:user)}
    before(:each) do
      sign_in user
      # sign_in FactoryGirl.create(:user)
      # FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      # FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "postranichnost" do
      before(:all){ 30.times {FactoryGirl.create(:user)}}
      after(:all){User.delete_all}
      it{should have_selector("div.pagination")}

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end
    describe "udalenie user_link" do
      it{should_not have_link("delete")}
      describe "kak admin" do
        let(:admin) {FactoryGirl.create(:admin)}
        before do
          sign_in admin
          visit users_path
        end
        it{should have_link("delete", user_path(User.first))}
        it "should admin have able del another user" do
          expect do
            click_link("delete", match: :first).to change(User, :count).by(-1)
          end
        end
        it{should_not have_link("delete", href: user_path(admin))}
      end
    end
  end
  describe "profile page" do
    let(:user) { create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }

    describe "follow/unfollow buttons" do
      let(:other_user) {FactoryGirl.create(:user)}
      before {sign_in user}

      describe "following a user" do
        before {visit user_path(other_user)}
        it 'should increment the followed user count' do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end
        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before{click_button "Follow"}
          it{should have_xpath("//input[@value='Unfollow']")}
        end
      end
      describe "unfollowing user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end
        it "umenshit na 1 followed user" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "umenshit na 1 followes user" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end
        describe "toggling the button" do
          before{click_button "Unfollow"}
          it{should have_xpath("//input[@value='Follow']")}
        end
      end
    end
  end

  describe "signup page" do
    before { visit signup_path }

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
      describe "posle zaprosa na registraciu: all fields are empty" do
        before { click_button submit }
        it {should have_title('Sign up')}
        it {should have_content("The form contains 6 errors")}
        it {should have_content("Name can't be blank")}
        it {should have_content("Email can't be blank")}
        it {should have_content("Email is invalid")}
        it {should have_content("Password can't be blank")}
        it {should have_content("Password is too short (minimum is 6 characters)")}
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
        it {should have_content("* Password confirmation doesn't match Password")}
      end
      describe "posle zaprosa na registraciu: without pass" do
        before do
          fill_in "Name",         :with => "Example User"
          fill_in "Email",        :with => "Examaple@mail.com"

          click_button submit
        end
        it {should have_title('Sign up')}
        it { should have_content('The form contains 2 errors')}
        it {should have_content("Password can't be blank")}
        it {should have_content('Password is too short (minimum is 6 characters)')}
      end

    end
  end
    describe "with valid info" do
      before { visit '/signup'}

      let(:submit) { "Create my account" }
      before do
        fill_in "Name",         :with => "Example User"
        fill_in "Email",        :with => "Examaple@mail.com"
        fill_in "Password",     :with => "foobar"
        fill_in "Confirmation", :with => "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      #it i self add
      # describe "posle zaprosa na registraciu" do
      #   let(:user) { create(:user) }
      #   before { click_button submit }
      #   it { should have_content('Welcome to the Sample app') }
      #   it { should have_title(user.name)}
      # end

      describe "posle soxranenia user'a" do
        #let(:user) { create(:user) }
        before { click_button submit }
        let(:user) { User.find_by(email: "examaple@mail.com") }

        it { should have_title(user.name)}
        it { should have_link("Sign out")}
        it { should have_selector('div.alert.alert-success', text:'Welcome to the Sample app') }

        # describe 'vyzov vypadaushego menu' do
        #   before {click_link "Home" }
        #   it { should have_content("Sign out") }
        #   it { should have_link("Profile") }
        # end
      end

    end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user)}
    before do
      sign_in user
      visit  edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1', text: "Update your profile")}
      it { should have_title("Edit user")}
      it { should have_link("change", href: "http://gravatar.com/emails")}

      describe "s oshibochnoi infoi" do
        before {click_button "Save change"}
        it {should have_content("error")}
      end
    end

    describe "otkaz v ustanovke" do
      let(:params) do
        {user: {admin: true, password: user.password,
        password_confirmation: user.password}}
      end
      before do
        sign_in user, no_capybara:true
        path user_path(user), params
      end
      specify{expect(user.reload).not_to be_admin}
    end

    describe "s valid info"  do
      let (:new_name) {"New Name"}
      let (:new_email) {"new@example.com"}
      before  do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it{should have_title(new_name)}
      it{should have_selector("div.alert.alert-success")}
      it{should have_link("Sign out", href: signout_path)}
      specify {expect(user.reload.name).to eq new_name }
      specify {expect(user.reload.email).to eq new_email }

      end
    end
  end
