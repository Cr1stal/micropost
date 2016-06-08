require 'spec_helper'
require_relative '../support/utilities'

Capybara.default_driver = :poltergeist#
Capybara.app_host = "http://localhost:3000"

describe "Autentifikacia" do

  subject { page }

  describe "signin page" do
    before { visit signin_path}

    it { should have_content('Sign in')}
    it { should have_title(full_title("Sign in")) }
  end

  describe "signin" do
    before { visit signin_path}

      describe "page s errors" do
        before { click_button "Sign in"}

        it {should have_title('Sign in')}
        it {should have_selector("div.alert.alert-error")}

        describe "posle perenapravlenia na druguu stranicu" do
          before { click_link "Home"}
          it { should_not have_selector("div.alert.alert-error")}
        end
      end


    describe "validnyi vxod" do
      let(:user) { FactoryGirl.create(:user)}
      # before  do
      #   fill_in "Email",   :with => user.email.upcase
      #   fill_in "Password",   :with => user.password
      #   click_button "Sign in"
      # end
      before {sign_in user}
      it {should have_title(user.name)}
      it {should have_link("Users",       href: users_path)}
      it {should have_link("Profile",     href: user_path(user))}
      it {should have_link("Settings",    href: edit_user_path(user))}
      it {should have_link("Sign out",    href: signout_path)}
      it {should_not have_link("Sign in", href: signin_path)}

      describe "vyxod s saita" do
        before {click_link "Sign out"}
        it {should have_link("Sign in")}
      end
    end
  end

  describe "authorization" do

    describe "dla nepodpisavsixca" do
      let(:user) {FactoryGirl.create(:user)}

      describe "kogda viziter poceshaet zashishennuu page " do
        before  do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "pocle perenapravlenia" do
          it "should otobrazit zashishennuu page" do
            expect(page).to have_title("Edit user")
          end
        end
      end

        describe "v users controllere" do

          describe "visiting edit page" do
            before {visit edit_user_path(user)}
            it{should have_title("Sign in")}
          end

          describe "popytka izmenit info" do
            before{patch user_path(user)}
            specify{expect(response).to redirect_to(signin_path)}
          end

          describe "posechenie user index" do
            before{visit users_path}
            it{should have_title("Sign in")}
          end
        end


      describe "in the Relationships controller" do
        describe "submitting to the create action" do
          before { post relationships_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end
    describe "kak ne pravilnyi user" do
      let(:user) {FactoryGirl.create(:user)}
      let(:wrong_user) {FactoryGirl.create(:user, email: "wrong@example.com")}
      before{sign_in user, no_capybara: true}

      describe "otpravka get'a User#edit deistviu" do
        before{get edit_user_path(wrong_user)}
        specify{expect(response.body).not_to match(full_title("Edit user"))}
        specify{expect(response).to redirect_to(root_url)}
      end

      describe "otpravka Patch zaprrosa User#update deistviu" do
        before{patch user_path(wrong_user)}
        specify{expect(response).to redirect_to(root_url)}
      end
    end

    describe "kak ne admin" do
      let(:user) {FactoryGirl.create(:user)}
      let(:non_admin) {FactoryGirl.create(:user)}
      before{sign_in non_admin, no_capybara: true}
      describe "popytka otoslat zapros DESTROY cheerez User#destroy deistvie" do
        before{delete user_path(user)}
        specify{expect(response).to redirect_to(root_url)}
      end
    end
  end
end

