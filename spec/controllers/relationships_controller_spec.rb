require 'spec_helper'

describe "RelationshipsController" do
  let(:user) {FactoryGirl.create(:user)}
  let(:other_user){FactoryGirl.create(:user)}

  before{sign_in user, no_capybara: true}

  describe "create relat. s AJAX" do
    it "uvel Relat. schet" do
      expect do
        xhr :post, :create, relationship: {followed_id: other_user.id}
      end.to change(Relationship, :count).by(1)
    end
    it "respond s uspehom" do
        xhr :post, :create, relationship: {followed_id: other_user.id}
        expect(response).to be_success
    end
  end
  describe "unichtojhenie relat. s AJAX" do
    before { user.follow!(other_user) }
    let(:relationship) { user.relationships.find_by(followed_id: other_user) }

    it "umensh. Relat. schet" do
        expect do
          xhr :delete, :destroy, id: relationship.id
        end.to change(Relationship, :count).by(-1)
      end
      it "respond s uspehom" do
        xhr :delete, :destroy, id: relationship.id
        expect(response).to be_success
      end
  end
end
