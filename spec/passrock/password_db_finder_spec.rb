require 'spec_helper'

describe Passrock::PasswordDbFinder do

  let(:password_db) { passrock_password_db }
  let(:private_key) { passrock_private_key }
  let(:init_opts) { {:password_db => password_db, :private_key => private_key} }


  describe '.bcrypt_hash' do

    it 'calculates and returns the bcrypt password hash given a secret and salt' do
      secret = 'password'
      salt = private_key
      expect(described_class.bcrypt_hash(secret, salt)).to eq('$2a$07$c16iYVArVz3hYEvtakjiXO8jPyn2MxhVHlrY92EErobY/OCDNObhG')
    end

  end


  describe '#valid?' do

    let(:subject) { described_class.new(init_opts) }

    context 'password_db is a directory' do
      let(:password_db) { passrock_password_db }

      it 'returns true' do
        expect(subject).to be_valid
      end
    end

    context 'password_db is a file' do
      let(:password_db) { passrock_password_db_file }

      it 'returns true' do
        expect(subject).to be_valid
      end
    end

    context 'password_db is does not exist as a file or directory' do
      let(:password_db) { '/invalid/path/to/password_db' }

      it 'returns false' do
        expect(subject).to_not be_valid
      end
    end

  end

  describe '#filename' do

    let(:subject) { described_class.new(init_opts) }

    context 'password_db is a directory' do
      let(:password_db) { passrock_password_db }

      it 'returns the filename based on the integer ordinal of the first character of the given hashed password' do
        hashed_password = 'g+vOBRu/5hi40RA5'
        expect(subject.filename(hashed_password)).to eq("#{password_db}/PRbinary#{hashed_password[0].ord}.dat")
      end
    end

    context 'password_db is a file' do
      let(:password_db) { passrock_password_db_file }

      it 'returns the password_db as the filename verbatim' do
        expect(subject.filename).to eq(passrock_password_db_file)
      end
    end

  end

  describe '#find' do

    let(:subject) { described_class.new(init_opts) }
    let(:known_password) { 'password' }
    let(:unknown_password) { 'BoatActKnowsDog' }

    context 'when given password is present in the password database' do
      it 'returns the Base64 representation of the hashed password' do
        expect(subject.find(known_password)).to eq('+lR0p4OzjXJnta/4')
      end
    end

    context 'when given password is mixed cased' do
      it 'returns the Base64 representation of the hashed password ignoring case' do
        expect(subject.find(known_password.upcase)).to eq('+lR0p4OzjXJnta/4')
      end
    end

    context 'when given password does not appear in the password database' do
      it 'returns true' do
        expect(subject.find(unknown_password)).to be_nil
      end
    end

    context 'when password_db does not exist' do
      let(:password_db) { '/invalid/path/to/password_db' }

      it 'raises PasswordDbNotFoundError' do
        expect {
          subject.find(known_password)
        }.to raise_error(Passrock::PasswordDbNotFoundError)
      end
    end

    context 'multiple sequential calls' do
      it 'does not error out' do
        expect {
          subject.find(unknown_password)
          subject.find(known_password)
        }.to_not raise_error
      end
    end

  end

end
