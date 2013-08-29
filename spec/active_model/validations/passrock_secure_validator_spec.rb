require 'spec_helper'

class TestRecord
  include ActiveModel::Validations
  attr_accessor :password

  def initialize(password)
    @password = password
  end
end

describe ActiveModel::Validations::PassrockSecureValidator do
  let(:password_db) { passrock_password_db }
  let(:private_key) { passrock_private_key }
  let(:field) { :password }

  describe '#validate_each' do

    before(:each) do
      TestRecord.validates(field, :passrock_secure => true)

      Passrock.configure do |config|
        config.password_db = password_db
        config.private_key = private_key
      end

      #I18n.backend.reload!
    end

    it 'validates the attribute with the Passrock DB for compromised passwords' do
      model = TestRecord.new('password')
      expect(model).to_not be_valid
      expect(model.errors.messages[field]).to eq(['appears to be a commonly used password'])
    end

  end

end
