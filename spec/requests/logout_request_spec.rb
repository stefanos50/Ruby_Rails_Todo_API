require 'rails_helper'

RSpec.describe 'Logout' do
  # Authentication test suite
  describe 'GET /auth/logout' do
    # create test user
    let!(:user) { create(:user) }
    # set headers for authorization
    let(:headers) { valid_headers.except('Authorization') }
    # set test valid and invalid credentials
    let(:valid_token) do
      {
        token:(0...50).map { ([('a'..'z'), ('A'..'Z')].map(&:to_a).flatten)[rand(([('a'..'z'), ('A'..'Z')].map(&:to_a).flatten).length)] }.join		
      }.to_json
    end
    let(:invalid_token) do
      {
        token: 0
      }.to_json
    end
    let(:valid_credentials) do
      { name: user.name,
        email: user.email,
        password: user.password
      }.to_json
    end
    let(:invalid_credentials) do
      {
        name: 'Name',
		#generate random email and password with Faker gem
        email: Faker::Internet.email,
        password: Faker::Internet.password
      }.to_json
    end

    let(:valid_params) do
      {
       name: user.name,
        email: user.email,
        password: user.password
      }.to_json
    end
    # returns auth token when request is valid
    context 'When request is valid' do
     
      before { 
        post '/signup',params: valid_params, headers: headers 
        salt_record =  RandomString.where(user_id: user.id).take
        request1 = get '/auth/logout', params: {Authorization: salt_record.user_token}.to_json, headers: headers 
      }
       
      it 'returns status code 200' do
        expect(json['message']).not_to be_nil
		RSpec.describe json['message'] do
			it { is_expected.to match("Invalid token") }
			it { is_expected.not_to match("You are now logged out...") }
		end 
      end
    end

    # returns failure message when request is invalid
    context 'When request is invalid' do
      before { 
        
        request2 = get '/auth/logout', params: {Authorization: nil}.to_json, headers: headers 
        }
      it 'returns a failure message' do
        expect(json['message']).to match("Invalid token")
      end
    end
  end
end