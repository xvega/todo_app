require 'byebug'

module TaskHelper

  def create_task(task_id)
    Task.create!(task_id)
  end

  def remove_task(task_id)
    Task.delete(task_id)
  end

  def select_task(task_id)
    @current_user&.tasks&.find(task_id)
  end

  def update_task_status(task, new_status)
    task.status = new_status
    task.save!
  end

  def filter_completed_tasks
    @current_user.tasks.completed
  end

  def filter_uncompleted_tasks
    @current_user.tasks.uncompleted_tasks
  end
end
