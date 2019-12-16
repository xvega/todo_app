class Task < ActiveRecord::Base
  enum status: { todo: 0, inprogress: 1, completed: 2 }
  belongs_to :user

  validates :title, :content, :user, presence: true

  scope :uncompleted_tasks, -> { where(status: %w[todo inprogress]) }
end
