FactoryBot.define do
  factory :task do
    title { 'My first todo' }
    content { 'Some content' }
    user
  end
end
