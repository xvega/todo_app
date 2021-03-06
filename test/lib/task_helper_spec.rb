require File.expand_path('../../../test/spec_helper', __FILE__)
require File.expand_path('../../../app/models/user', __FILE__)
require File.expand_path('../../../app/models/task', __FILE__)
require File.expand_path('../../../app/lib/task_helper', __FILE__)

RSpec.describe 'TaskHelper' do

  let(:test_class) do
    test_object = Object.new
    test_object.extend(TaskHelper)
  end

  context 'task creation' do

    describe '#create_task' do

      let(:current_user) { FactoryBot.create(:user) }

      describe 'when valid params' do

        let(:valid_params) do
          {
            title: 'task_title',
            content: 'task_content',
            user_id: current_user.id
          }
        end

        it 'creates a task' do
          allow(test_class).to receive(:create_task).and_call_original

          expect do
            task_creation = test_class.create_task(valid_params)
            expect(task_creation).to be_an_instance_of(Task)
          end.to change { Task.count }.by(1)
        end
      end

      describe 'when invalid params' do
        let(:invalid_params) do
          {
              title: 'task_title',
              content: 'task_content',
              user_id: nil
          }
        end

        it 'raises an error' do
          allow(test_class).to receive(:create_task).and_call_original
          expect { test_class.create_task(invalid_params) }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end

  context 'task update' do

    let(:task) { FactoryBot.create(:task) }
    let(:user) { task.user }

    describe '#select_task' do

      describe 'when there is a current_user' do

        it 'returns the user task' do
          allow(test_class).to receive(:select_task).and_call_original
          test_class.instance_variable_set(:@current_user, user)
          expect(test_class.select_task(task.id)).to eq(task)
        end
      end

      describe 'when there is no current_user' do

        it 'returns nil' do
          allow(test_class).to receive(:select_task).and_call_original
          test_class.instance_variable_set(:@current_user, nil)
          expect(test_class.select_task(task.id)).to eq(nil)
        end
      end

      describe 'when the selected task does not belong to the current_user' do

        let(:second_user) { FactoryBot.create(:user) }

        it 'raises an error' do
          allow(test_class).to receive(:select_task).and_call_original
          test_class.instance_variable_set(:@current_user, second_user)
          expect do
            test_class.select_task(task.id)
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe '#update_task_status' do

      let(:uncompleted_task) { FactoryBot.create(:uncompleted_task) }

      describe 'with a valid status' do

        it 'updates the status' do
          allow(test_class).to receive(:update_task_status).and_call_original
          test_class.instance_variable_set(:@current_user, nil)

          expect do
            test_class.update_task_status(uncompleted_task, 2)
          end.to change { uncompleted_task.reload.status }.from('inprogress').to('completed')

        end
      end

      describe 'with an invalid status' do

        it 'raises an error' do
          allow(test_class).to receive(:update_task_status).and_call_original
          test_class.instance_variable_set(:@current_user, uncompleted_task.user)

          expect do
            test_class.update_task_status(uncompleted_task, 999999)
          end.to raise_error(ArgumentError)
        end
      end
    end
  end

  context 'task removal' do

    describe '#remove_task' do

      let!(:task) { FactoryBot.create(:task) }

      describe 'when the task to be removed exists' do

        it 'is successfully removed' do
          allow(test_class).to receive(:update_task_status).and_call_original
          expect do
            test_class.remove_task(task.id)
          end.to change { Task.count }.from(1).to(0)
        end
      end

      describe 'when the task to be removed does not exist' do

        it 'is not removed' do
          allow(test_class).to receive(:update_task_status).and_call_original
          expect do
            test_class.remove_task(999999)
          end.to_not change(Task, :count)
        end
      end
    end
  end

  context 'task filtering' do

    let(:user) { FactoryBot.create(:user) }

    let!(:task) { FactoryBot.create(:task, user_id: user.id) }
    let!(:completed_task) { FactoryBot.create(:completed_task, user_id: user.id) }
    let!(:completed_task_two) { FactoryBot.create(:completed_task_two, user_id: user.id) }
    let!(:completed_task_three) { FactoryBot.create(:completed_task_three, user_id: user.id) }

    describe '#filter_completed_tasks' do

      it 'gets the completed tasks' do
        allow(test_class).to receive(:filter_completed_tasks).and_call_original
        test_class.instance_variable_set(:@current_user, user)
        expect(test_class.filter_completed_tasks.count).to eq(3)
      end
    end

    describe '#filter_uncompleted_tasks' do

      it 'gets the uncompleted tasks' do
        allow(test_class).to receive(:filter_uncompleted_tasks).and_call_original
        test_class.instance_variable_set(:@current_user, user)
        expect(test_class.filter_uncompleted_tasks.count).to eq(1)
      end
    end
  end

  context 'input/output methods' do

    let(:user) { FactoryBot.create(:user) }

    describe '#tasks_empty?' do
      it 'returns a string if there are no tasks' do
        allow(test_class).to receive(:tasks_empty?).and_call_original
        test_class.instance_variable_set(:@current_user, user)
        expect(test_class.tasks_empty?).to eq('Create a task first')
      end
    end

    describe '#task_selection' do

      let(:task) { FactoryBot.create(:task, user_id: user.id) }

      describe 'when the task id is valid' do
        it 'returns a task' do
          allow(test_class).to receive(:task_selection).and_call_original
          allow(test_class).to receive(:user_input).and_return(task.id)
          test_class.instance_variable_set(:@current_user, user)
          expect(test_class.task_selection).to be_an_instance_of(Task)
        end
      end

      describe 'when the task id is not valid' do
        it 'returns nil' do
          allow(test_class).to receive(:task_selection).and_call_original
          allow(test_class).to receive(:user_input).and_return(999999)
          test_class.instance_variable_set(:@current_user, user)
          expect(test_class.task_selection).to eq(nil)
        end
      end
    end

    describe '#task_removal_input' do
      describe 'when there are no tasks' do
        it 'returns a message' do
          allow(test_class).to receive(:task_removal_input).and_call_original
          expect(test_class.task_removal_input(999999)).to eq('Please select a valid task ID')
        end
      end

      describe 'when there are tasks to be removed' do

        let(:task) { FactoryBot.create(:task, user_id: user.id) }

        it 'returns a message' do
          allow(test_class).to receive(:task_removal_input).and_call_original
          expect(test_class.task_removal_input(task.id)).to eq('Please select a valid task ID')
        end
      end
    end

    describe '#task_creation_input' do
      describe 'when the task is created successfully' do

        let(:message) { "Created a task for user #{user.username}" }

        it 'returns a message' do
          allow(test_class).to receive(:user_input).and_return('any text')
          test_class.instance_variable_set(:@current_user, user)
          expect(test_class.task_creation_input).to eq(message)
        end
      end

      describe 'when the task is not created' do

        let(:message) { "Validation failed: Title can't be blank, Content can't be blank" }

        it 'returns an error message' do
          allow(test_class).to receive(:user_input).and_return(nil)
          test_class.instance_variable_set(:@current_user, user)
          expect(test_class.task_creation_input).to eq(message)
        end
      end
    end
  end
end
