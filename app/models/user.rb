class User < ActiveRecord::Base
  has_many :tasks

  validates :username, presence: true, uniqueness: true
end
