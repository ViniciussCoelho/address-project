require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_presence_of(:password) }
  it { should validate_length_of(:password).is_at_least(6) }
  it { should validate_presence_of(:name) }
  it { should have_many(:contacts).dependent(:destroy) }

  describe 'devise jwt' do
    it 'authenticates the user using the email and password' do
      user = User.create(email: 'user@example.com', password: 'password', name: 'User')
      expect(User.find_by_email(user.email).valid_password?('password')).to be_truthy
      expect(User.find_by_email(user.email).valid_password?('wrong_password')).to be_falsey
    end

    it 'registers a new user' do
      user = User.new(email: 'user@example.com', password: 'password', name: 'User')
      expect(user.save).to be_truthy

      invalid_user = User.new(email: 'user@example.com', password: 'password', name: '')
      expect(invalid_user.save).to be_falsey
    end

    it 'validates the presence of the email and password' do
      user = User.new(email: '', password: 'password', name: 'User')
      expect(user.save).to be_falsey
      expect(user.errors[:email]).to include("can't be blank")

      user = User.new(email: 'user@example.com', password: '', name: 'User')
      expect(user.save).to be_falsey
      expect(user.errors[:password]).to include("can't be blank")
    end
  end
end