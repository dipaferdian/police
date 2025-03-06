require 'rails_helper'

RSpec.describe Office, type: :model do
  
  describe 'associations' do
    it { should have_many(:officers) }
  end
end
