require File.expand_path('../../../test/spec_helper', __FILE__)
require File.expand_path('../../../app/models/user', __FILE__)

RSpec.describe User do

  let(:user) { FactoryBot.create(:user) }

  describe 'creation' do

    it 'can be created' do
      expect(user).to be_valid
    end
  end

  describe 'validations' do

    it 'cannot be created without a username' do
      user.username = nil
      expect(user).to_not be_valid
    end

    it 'does not create a dup username' do
      dup_user = FactoryBot.build(:user, username: user.username)
      expect(dup_user).to_not be_valid
    end
  end
end
