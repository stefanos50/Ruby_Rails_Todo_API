require 'rails_helper'

RSpec.describe RandomString, type: :model do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:random_str) }
    it { should validate_presence_of(:user_token) }
end
