require 'spec_helper'

describe Relationship do
  let(:follower) {FactoryGirl.create(:user)}
  let(:followed) {FactoryGirl.create(:user)}
  let(:relationship) {follower.relationships.build(followed_id: followed.id)}

  subject{relationship}
  it{should be_valid}
  describe "follower methods" do
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }

    it {expect(subject.follower).to eq follower }
    it {expect(subject.followed).to eq followed }
  end
end
