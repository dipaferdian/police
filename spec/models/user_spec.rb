require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do

    it "is invalid without a username, password, email" do
      user = build(:user, username: nil, password: nil, email: nil) # Use build instead of create
      expect(user).not_to be_valid
    end

    it "is invalid without a username" do
      user = build(:user, username: nil) # Use build instead of create
      expect(user).not_to be_valid
    end
    
    it 'validates email format' do
      user = build(:user)
      expect(user).to be_valid

      user.email = 'invalid_email'
      expect(user).not_to be_valid
      
      user.email = 'valid@email.com'
      expect(user).to be_valid
    end
  end

  describe 'secure password' do
    
    it 'hashes the password' do
      user = create(:user, password: 'password123')
      expect(user.password_digest).not_to eq 'password123'
      expect(user.authenticate('password123')).to eq user
    end
  end
end
