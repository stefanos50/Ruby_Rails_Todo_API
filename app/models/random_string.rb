class RandomString < ApplicationRecord
    validates_presence_of :user_id, :random_str, :user_token
end
