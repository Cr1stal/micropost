require 'rails_helper'

# RSpec.describe "MicropostPages", type: :request do
#   describe "GET /micropost_pages" do
#     it "works! (now write some real specs)" do
#       get micropost_pages_index_path
#       expect(response).to have_http_status(200)
#     end
#   end
# end
RSpec.describe "MicropostPages" do
  subject {page}

  let(:user) {FactoryGirl.create(:user)}
  before{sign_in user}
  describe "sozdat soobshenie" do
    before{visit root_path}

    describe "with inval info" do
      it "ne sozdal micropost" do
        expect{click_button "Post"}.not_to change(Micropost, :count)
      end

      describe "err mess" do
        before {click_button "Post"}
        it{should have_content("error")}
      end
    end

    describe "with inval info" do
      before{fill_in "micropost_content", with: "Something else"}
      it "should create micropost" do
        expect{click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end

  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end
end