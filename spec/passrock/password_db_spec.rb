require 'spec_helper'

describe Passrock::PasswordDb do

  let(:password_db) { passrock_password_db }
  let(:private_key) { passrock_private_key }
  let(:valid_init_opts) { {:password_db => password_db, :private_key => private_key} }
  let(:insecure_password) { 'password' }
  let(:secure_password) { 'BoatActKnowsDog' }


  describe '.bcrypt_hash' do

    it 'calculates and returns the bcrypt password hash given a secret and salt' do
      secret = 'password'
      salt = private_key
      expect(described_class.bcrypt_hash(secret, salt)).to eq('$2a$07$c16iYVArVz3hYEvtakjiXO8jPyn2MxhVHlrY92EErobY/OCDNObhG')
    end

  end


  describe '#initialize' do

    context 'when password_db base directory does not exist' do
      it 'raises PasswordDbDirectoryNotFoundError' do
        expect {
          described_class.new(:password_db => '/invalid/path/to/password_db', :private_key => private_key)
        }.to raise_error(Passrock::PasswordDbDirNotFoundError)
      end
    end

  end

  describe '#secure?' do

    let(:subject) { described_class.new(valid_init_opts) }

    context 'when given password is present in the password database' do
      it 'returns false' do
        expect(subject.secure?(insecure_password)).to be_false

        # sanity check other known insecure passwords
        #[ 'inIUfiWO13', 'PVGWpkf81', 'cSAuOcUW58', 'XxPRBGF11', 'WjNYUmGj72', 'P0RQU33SM3N3ST3r' ].each do |password|
        [ 'inIUfiWO13', 'PVGWpkf81' ].each do |password|
          expect(subject.secure?(password)).to be_false
        end
      end
    end

    context 'when given password does not appear in the password database' do
      it 'returns true' do
        expect(subject.secure?(secure_password)).to be_true
      end
    end

    context 'multiple sequential calls' do
      it 'does not error out' do
        expect {
          subject.secure?(secure_password)
          subject.secure?(insecure_password)
        }.to_not raise_error
      end
    end


  end

  describe '#insecure?' do

    let(:subject) { described_class.new(valid_init_opts) }

    context 'when given password is present in the password database' do
      it 'returns true' do
        expect(subject.insecure?(insecure_password)).to be_true
      end
    end

    context 'when given password does not appear in the password database' do
      it 'returns false' do
        expect(subject.insecure?(secure_password)).to be_false
      end
    end

  end

  describe '#password_in_searchable_form' do

    let(:subject) { described_class.new(valid_init_opts) }

    it 'returns the given password in a searchable format' do
      expect(subject.password_in_searchable_form(insecure_password)).to eq('+lR0p4OzjXJnta/4')
    end

    context 'when given password is mixed cased' do
      it 'returns the given password in a searchable format ignoring case' do
        expect(subject.password_in_searchable_form(insecure_password.upcase)).to eq('+lR0p4OzjXJnta/4')
      end
    end

  end

  describe '#password_db_file' do

    let(:subject) { described_class.new(valid_init_opts) }

    it 'returns the db file to check based on the given hashed password' do
      expect(subject.password_db_file('g+vOBRu/5hi40RA5')).to eq("#{password_db}/PRbinaryg.dat")
    end

    context 'when first char of the hashed password is a /' do
      it 'returns !' do
        expect(subject.password_db_file('/FOOBAR')).to eq("#{password_db}/PRbinary!.dat")
      end
    end

  end

end
