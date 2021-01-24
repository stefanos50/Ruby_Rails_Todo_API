require 'rails_helper'

RSpec.describe LogoutUser do
    let(:valid_token) {(0...50).map { ([('a'..'z'), ('A'..'Z')].map(&:to_a).flatten)[rand(([('a'..'z'), ('A'..'Z')].map(&:to_a).flatten).length)] }.join}
    let(:invalid_token) { nil }

    describe '#call' do
        context 'when valid token' do
            
            it 'returns a token invalidation message' do
                message = LogoutUser.new(valid_token).call
                expect(message).not_to be_nil
            end

        end

        context 'when invalid token' do
            it 'raises an authentication error' do
                raise_error(ExceptionHandler::InvalidToken, /invalid token/)
            end
        end

    end
end