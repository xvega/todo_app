module UserHelper

  def user_creation(username)
    User.create!(username: username)
  end

  def log_in(username)
    @current_user ||= User.find_by(username: username)
  end

  def create_user_and_login(username)
    begin
      @current_user ||= user_creation(username)
      unless @current_user
        p "User #{@current_user.username} created successfully!"
        log_in(@current_user.username)
      end
      p "Logged as #{@current_user.username} until you quit the app and select a different user"
      @current_user
    rescue ActiveRecord::RecordInvalid => e
      puts e.message
      @current_user = nil
    end
  end
end
