require File.expand_path('../../../test/spec_helper', __FILE__)
require File.expand_path('../../../app/models/user', __FILE__)
require File.expand_path('../../../app/lib/task_helper', __FILE__)

RSpec.describe 'TaskHelper' do

  let(:test_class) do
    test_object = Object.new
    test_object.extend(TaskHelper)
  end

  context 'task creation' do

    xit 'associates the task to the current_user' do

    end

    describe 'with valid params' do
      xit 'allows to create a task' do

      end
    end

    describe 'with invalid params' do
      xit 'does not allow to create a task' do

      end
    end
  end

  context 'task update' do
    describe 'with valid status' do
      xit 'allows to transition to a different status' do
      end
    end

    describe 'with invalid status' do
      xit 'does not allow to transition to a different status' do

      end
    end
  end

  context 'task removal' do
    describe 'when the task exists' do
      describe 'and the task belongs to the current_user' do
        xit 'is successfully removed' do

        end
      end

      describe 'and the task does not belong to the current_user' do
        xit 'is not removed' do

        end
      end

    end
  end

  context 'task filtering' do

    xit 'does not include other users tasks' do

    end

    xit 'gets the completed tasks' do

    end

    xit 'gets the uncompleted tasks' do

    end
  end
end
