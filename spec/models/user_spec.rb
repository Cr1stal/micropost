require 'spec_helper'
require "utilities"

Capybara.default_driver = :poltergeist#
Capybara.app_host = "http://localhost:3000"

describe User do

  before do
    @user = User.new(name: "Example user", email: "user@mail.com",
                     password: "foobarly", password_confirmation: "foobarly")
  end

  subject { @user }

  it {should respond_to(:name)}
  it {should respond_to(:email)}
  it {should respond_to(:password_digest)}

  it {should respond_to(:password)}
  it {should respond_to(:password_confirmation)}

  #it { should respond_to(:authenticate) }
  it {should respond_to(:password_confirmation)}
  it {should respond_to(:remember_token)}
  it {should respond_to(:authenticate)}
  it {should respond_to(:admin)}
  it {should respond_to(:microposts)}
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }

  it {should be_valid}
  it {should_not be_admin}

  describe "s admin atrr. set 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    it {should be_admin}
  end
  describe 'when name is not present' do
    before { @user.name = " " }
    it { should_not be_valid }
    end
  describe 'when name is too long' do
      before { @user.name = "a" * 51 }
      it { should_not be_valid }
    end
  describe 'when email is not present' do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "perevod v nijhnii registr email" do
    let(:mixe_case_email) {"Foo@ExaMple.CoM" }

    it 'should be saved as all lower-case' do
      @user.email = mixe_case_email
      @user.save
      expect(@user.reload.email).to eq mixe_case_email.downcase
    end
  end

  describe "email.valid? -> false" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.og exa.user@foo. foo@bar_ban.com foo@@tar+klar.com foo@bar..com ]
      addresses.each do |inval_add|
        @user.email = inval_add
        expect(@user).not_to be_valid
      end
    end
  end

  describe "email.valid? -> true" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lstr@foo.jp a+b@taz.cn]
      addresses.each do |val_add|
        @user.email = val_add
        expect(@user).to be_valid
      end
    end
  end

  describe "when email addres is already taken" do
      before do
        user_with_same_email = @user.dup
        user_with_same_email.email = @user.email.upcase
        user_with_same_email.save
      end
    it { should_not be_valid }
  end

  describe "kogda pass is not " do
      before do
        @user = User.new(name: "Example User", email: "user@mail.com",
                         password: " ", password_confirmation: " ")
      end
      it { should_not be_valid } # false
  end

  describe "when pass doesn't {p1 == p2} " do
    before { @user.password_confirmation = "mismatch"}
    it {should_not be_valid}
  end

  describe "when pass is too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid } #false
  end

  describe "return znachenie metoda validacii" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email)}

    describe "normal pass" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "pass ne sovpall" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid")}

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_falsey } # false if be_false why?
    end

  end

  describe "pomnit' token" do
    before { @user.save }
    #its(:remember_token) { should_not be_blank}
    it { expect(@user.remember_token).not_to be_blank}
  end

  describe "micropost associations" do

    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
        end

      before do
        @user.follow!(followed_user)
        3.times {followed_user.microposts.create!(content: "Something else")}
      end

      it{expect(@user.feed).to include(newer_micropost) }
      #its(:feed) { should include(older_micropost) }
      it {expect(@user.feed).to include(older_micropost) }
      it {expect(@user.feed).not_to include(unfollowed_post) }
      it "something "do
        expect do
          @user.followed_user
        end
      end

      it {expect(followed_user_microposts).to all be_in(@user.feed)  }
      #its(:feed) {followed_user.microposts.each { |micropost|  should include(micropost) }  }
    end
  end

end
