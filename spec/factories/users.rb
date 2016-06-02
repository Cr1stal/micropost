FactoryGirl.define do
  # factory :user do
  #   name  "Tem Rogman"
  #   email  "rogmantem@example.com"
  #   password "foobar"
  #   password_confirmation "foobar"
  # end
  factory :user do
    name "Example User"
    email  "example@railstutorial.org"
    password "foobar"
    password_confirmation "foobar"
  end
end
