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


    invalid_option_msg = 'Please select a valid option'
    username_input_msg = 'Enter a username'
    welcome_msg        = '########## Welcome to the TODO app! ##############'
    goodbye_msg        = 'Thanks for using the app!'
    invalid_user_msg   = 'The provided username does not exist'

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
        puts 'task logic in process..'
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
