FactoryBot.define do
  sequence :username do |n|
    "test#{n}.com"
  end

  factory :user do
    username { generate :username }
  end

  factory :user_two, class: 'User' do
    username { generate :username }
  end
end
