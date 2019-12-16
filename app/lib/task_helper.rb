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

  def display_user_tasks
    tasks_iterator(@current_user&.tasks.reload)
  end

  def pp_selected_task(task)
    puts '######################################'
    puts "ID: #{task.id}"
    puts "Status: #{task.status}"
    puts "Title: #{task.title}"
    puts "Content: #{task.content}"
    puts '######################################'
  end

  def tasks_empty?
    'Create a task first' if @current_user&.tasks&.empty?
  end

  def tasks_iterator(tasks)
    return if tasks_empty?

    tasks.each do |task|
      pp_selected_task(task)
    end
  end

  def task_selection
    display_user_tasks
    p 'Select a task id'
    begin
      select_task(user_input)
    rescue ActiveRecord::RecordNotFound
      p 'Please select a valid task ID'
      nil
    end
  end

  def task_removal_input(task_id)
    task = @current_user&.tasks&.find_by(id: task_id)
    if task.nil?
      'Please select a valid task ID'
    else
      remove_task(task.id)
      'The task has been deleted'
    end
  end

  def task_update_input(task_status_menu)
    return if tasks_empty?

    task = task_selection
    return unless task

    print task_status_menu
    new_status = user_input.to_i
    prev_status = task.status
    begin
      update_task_status(task, new_status)
      p "The status has been switch from #{prev_status} to #{task.status}"
    rescue ArgumentError => e
      p e.message
    end
    pp_selected_task(task)
  end

  def task_creation_input
    p '############# Task Creation #############'
    p 'Enter a title: '
    task_title = user_input
    p 'Enter the content: '
    task_content = user_input

    begin
      create_task(
        title: task_title,
        content: task_content,
        user_id: @current_user.id
      )
      'Created a task for user ' + @current_user.username
    rescue ActiveRecord::RecordInvalid => e
      e.message
    end
  end
end
