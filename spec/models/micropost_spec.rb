require 'spec_helper'

#RSpec.describe Micropost, type: :model do
describe "Micropost" do
  let(:user) {FactoryGirl.create(:user)}
  before{@micropost = user.microposts.build(content: "Something else")}
  subject{@micropost}
  it{should respond_to(:content)}
  it{should respond_to(:user_id)}
  it{should respond_to(:user)}
  #its(:user) { should eq user }
  it 'should eq user' do
    expect(subject.user).to eq user
  end

  it{should be_valid}
  describe "kogda user_id ne predstavleno" do
    before{@micropost.user_id = nil}
    it{should_not be_valid}
  end
end
