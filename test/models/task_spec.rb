require File.expand_path('../../../test/spec_helper', __FILE__)
require File.expand_path('../../../app/models/task', __FILE__)
require File.expand_path('../../../app/models/user', __FILE__)

RSpec.describe Task do

  let(:user) { FactoryBot.create(:user) }
  let(:task) { FactoryBot.create(:task, user_id: user.id) }

  describe 'creation' do

    it 'can be created' do
      expect(task).to be_valid
    end

    it 'initializes with a todo status' do
      expect(task.status).to eq('todo')
    end

    it 'belongs to a user' do
      expect(task.user_id).to eq(user.id)
    end
  end

  describe 'validations' do

    it 'cannot be created without a title' do
      task.title = nil
      expect(task).to_not be_valid
    end

    it 'cannot be created without content' do
      task.content = nil
      expect(task).to_not be_valid
    end

    it 'cannot be created without a user' do
      task.user_id = nil
      expect(task).to_not be_valid
    end
  end
end
