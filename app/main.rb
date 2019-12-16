require 'active_record'

require_relative './models/user'
require_relative './models/task'
require_relative './lib/task_helper'
require_relative './lib/user_helper'

class Main

  include UserHelper
  include TaskHelper

  def initialize
    ActiveRecord::Base.establish_connection(db_configuration["development"])
  end

  def gui
    menu               = "
                         ##########################
                         # 1. Users               #
                         # 2. Tasks               #
                         # q. Exit                #
                         ##########################\n"

    user_menu          = "
                         ##########################
                         # 1. Select a user       #
                         # 2. Create a user       #
                         # b. Back                #
                         ##########################\n"

    task_menu          = "
                         ##########################
                         # 1. Create a task       #
                         # 2. Update task status  #
                         # 3. List tasks          #
                         # 4. Completed tasks     #
                         # 5. Uncompleted tasks   #
                         # 6. Remove a task       #
                         # b  Back                #
                         ##########################\n"

    task_status_menu   = "\n
                         Select a new status\n
                         0. Todo
                         1. In-Progress
                         2. Completed
                         \n"

    invalid_option_msg = 'Please select a valid option'
    username_input_msg = 'Enter a username'
    nothing_to_remove  = 'Please create a task in order to use this functionality'
    no_tasks_msg       = 'There are no tasks available'
    removal_msg        = 'Please select a task to remove'
    invalid_user_msg   = 'The provided username does not exist'
    login_warning_msg  = 'Please log in first to use the app'
    welcome_msg        = '########## Welcome to the TODO app! ##############'
    goodbye_msg        = 'Thanks for using the app!'
    puts welcome_msg

    loop do
      puts menu

      case user_input
      when '1'
        print user_menu
        case user_input
        when '1'
          p username_input_msg
          @current_user = log_in(user_input)
          p @current_user.nil? ? invalid_user_msg : "Logged as #{@current_user.username}"
        when '2'
          p username_input_msg
          username = user_input
          @current_user = create_user_and_login(username)
        when 'b'
          clear_screen
          next
        else
          puts invalid_option_msg
        end

      when '2'
        if @current_user.nil?
          p login_warning_msg
          next
        end
        print task_menu
        case user_input
        when '1'
          p task_creation_input
        when '2'
          clear_screen
          p task_update_input(task_status_menu)
        when '3'
          clear_screen
          display_user_tasks
        when '4'
          p no_tasks_msg if filter_completed_tasks.empty?
          tasks_iterator(filter_completed_tasks)
        when '5'
          p no_tasks_msg if filter_uncompleted_tasks.empty?
          tasks_iterator(filter_uncompleted_tasks)
        when '6'
          if @current_user.tasks.count.zero?
            p nothing_to_remove
          else
            clear_screen
            p removal_msg
            display_user_tasks
            p task_removal_input(user_input)
          end
        when 'b'
          clear_screen
          next
        else
          puts invalid_option_msg
        end
      when 'q'
        p goodbye_msg
        break
      else
        puts invalid_option_msg
      end
    end
  end

  private

  def clear_screen
    system 'clear'
  end

  def user_input
    print '>>>: '
    gets.chomp.downcase
  end

  def db_configuration
    db_configuration_file = File.join(File.expand_path('..', __FILE__), '..', 'db', 'config.yml')
    YAML.load(File.read(db_configuration_file))
  end
end

main = Main.new
main.gui
