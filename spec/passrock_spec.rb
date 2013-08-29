require 'spec_helper'

describe Passrock do

  describe '.configure' do

    before(:each) do
      Passrock.reset_configuration!
    end

    it 'allows configuration to be set with a block' do
      Passrock.configure do |config|
        config.password_db = '/path/to/db'
        config.private_key = 'abc12345'
      end

      expect(Passrock.configuration.password_db).to eq('/path/to/db')
      expect(Passrock.configuration.private_key).to eq('abc12345')
    end

  end

end
