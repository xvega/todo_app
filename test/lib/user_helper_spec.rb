require File.expand_path('../../../test/spec_helper', __FILE__)
require File.expand_path('../../../app/models/user', __FILE__)
require File.expand_path('../../../app/lib/user_helper', __FILE__)

RSpec.describe 'UserHelper' do

  let(:test_class) do
    test_object = Object.new
    test_object.extend(UserHelper)
  end

  let(:username) { 'test_username' }

  context '#user_creation' do

    describe 'with a non-existing username' do

      it 'creates a new user' do
        expect do
          created_user = test_class.user_creation(username)
          expect(created_user.username).to eq(username)
        end.to change { User.count }.by(1)
      end
    end

    describe 'with an existing username' do

      let(:user) { FactoryBot.create(:user) }

      it 'raises an error' do
        allow(test_class).to receive(:user_creation).and_call_original
        expect { test_class.user_creation(user.username) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  context '#create_user_and_login' do

    let(:username) { 'create_and_login' }
    let(:user) { FactoryBot.create(:user) }

    describe 'when a user can be created and logged in' do

      it 'creates a new user record' do
        allow(test_class).to receive(:create_user_and_login).and_call_original
        expect { test_class.create_user_and_login(user.username) }.to change(User, :count)
      end

      it 'logs in the user' do
        allow(test_class).to receive(:create_user_and_login).and_call_original
        test_class.create_user_and_login(username)
        expect(test_class.instance_variable_get(:@current_user)).to be_an_instance_of(User)
      end
    end

    describe 'when a user cannot be created' do

      let!(:user) { FactoryBot.create(:user) }

      it 'does not create a new user record' do
        allow(test_class).to receive(:create_user_and_login).and_call_original
        expect { test_class.create_user_and_login(user.username) }.to_not change(User, :count)
      end

      it 'does not log in a user' do
        allow(test_class).to receive(:create_user_and_login).and_call_original
        test_class.create_user_and_login(user.username)
        expect(test_class.instance_variable_get(:@current_user)).to eq(nil)
      end
    end
  end

  context '#log_in' do
    describe 'with an existing user' do

      let!(:user) { FactoryBot.create(:user) }

      it 'logs in the user' do
        allow(test_class).to receive(:log_in).and_call_original
        expect(test_class.log_in(user.username)).to be_an_instance_of(User)
      end
    end

    describe 'with a non-existing user' do

      let(:non_existing_user) { 'brand_new_username' }

      it 'does not log in the user' do
        allow(test_class).to receive(:log_in).and_call_original
        expect(test_class.log_in(non_existing_user)).to eq(nil)
      end
    end

    describe 'when logged in and log in another user' do

      let!(:user) { FactoryBot.create(:user) }
      let!(:second_user) { FactoryBot.create(:user) }

      it 'does not change the logged in user' do
        test_class.instance_variable_set(:@current_user, user)
        allow(test_class).to receive(:log_in).and_call_original
        expect(test_class.log_in(user.username)).to be_an_instance_of(User)
        expect(test_class.instance_variable_get(:@current_user)).to eq(user)
      end
    end

    describe 'when logged in and create a new user' do

      let!(:user) { FactoryBot.create(:user) }

      it 'does not change the logged in user' do
        allow(test_class).to receive(:log_in).and_call_original
        test_class.log_in(user.username)
        current_user = test_class.instance_variable_get(:@current_user)

        allow(test_class).to receive(:create_user_and_login).and_call_original
        test_class.create_user_and_login('second_user')
        user_creation = test_class.instance_variable_get(:@current_user)

        expect(current_user).to eq(user_creation)
      end
    end
  end
end
