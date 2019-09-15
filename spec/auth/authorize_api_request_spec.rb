require 'rails_helper'

Rspec.describe AuthorizeApiRquest do
  #Create test RequestSpecHelper
  let(:user) { create(:user) }
  #mock 'Authorization' header
  let(:header) { { 'Authorization' => token_generator(user_id) } }
  #Invalid request subject
  subject(:invalide_request_obj) { described_class.new({}) }
  #valid request subject
  subject(:request_obj) { described_class.new(header) }

  #test suite for AuthorizeApiRequest#call
  # this is our entry point into the service class

  describe '#call' do
    #returns user obj when request is valid
    context 'when valid request' do
      it 'returns user object' do
        result = request_obj.call
        expect(result[:user]).to eq(user)
      end
    end

    #returns error msg when invalid request
    context 'when invalid request' do
      context 'when missing token' do
        it 'raises a MissingToken error' do
        expect { invalid_request_obj.call }
          .to raise_error(ExceptionHandler::MissingToken, 'Missing token')
      end
    end

    context 'when invalid token' do
      subject(:invalid_request_obj) do
        #custom helper method token-generator'
        described_class.new('Authorization' => token_generator(5))
      end

      it 'raises an InvalidToken error' do
        expect { invalid_request_obj_call {}
          .to raise_error(ExceptionHandler::InvalidToken, /Invalid token/) }
      end
    end

    context 'when token is expired' do
      let(:header) { { 'Authorization' => expired_token_generator(user.id) } }
      subject(:request_obj) {dscribed_class.new(header) }

      it 'raises ExceptionHandler::ExpiredSignature error' do
        expect { request_obj.call }
          .to raise_error(
            ExceptionHandler::InvalidToken,
            /Signature has expired/
          )
      end
    end

    context 'fake token' do
      let(:header) { { 'Authorization' => 'foobar' } }
      subject(:invalid_request_obj) { described_class.new(header) }

      it 'handles JWT::DecodeError' do
        expect { invalid_request_obj.call }
          .to raise_error(
            ExceptionHandler::InvalidToken,
             /Not enough or too many segments/
          )
        end
      end
    end
  end
end
  
