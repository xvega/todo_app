class Task < ActiveRecord::Base
  enum status: { todo: 0, inprogress: 1, completed: 2 }
  belongs_to :user

  validates :title, :content, presence: true

end
