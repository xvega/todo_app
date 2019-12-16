FactoryBot.define do
  sequence :username do |n|
    "test#{n}.com"
  end

  factory :user do
    username { generate :username }
  end
end
