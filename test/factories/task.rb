FactoryBot.define do
  factory :task do
    title { 'My first todo' }
    content { 'Some content' }
    user
  end

  factory :uncompleted_task, class: 'Task' do
    title { 'Do the laundry' }
    content { 'Take all the clothes' }
    status { 1 }
    user
  end

  factory :completed_task, class: 'Task' do
    title { 'Go to the gym' }
    content { 'Today I change my routine' }
    status { 2 }
    user
  end

  factory :completed_task_two, class: 'Task' do
    title { 'Go for a walk' }
    content { 'Visit your favorite park' }
    status { 2 }
    user
  end

  factory :completed_task_three, class: 'Task' do
    title { 'Wash the dishes' }
    content { 'Scrape food residue off plates before washing' }
    status { 2 }
    user
  end

  factory :user_two_task, class: 'Task' do
    title { 'Prepare the dinner' }
    content { 'Remember to buy groceries' }
    status { 1 }
    user
  end
end
