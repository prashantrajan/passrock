require 'spec_helper'

describe Passrock::PasswordDb do

  let(:password_db) { passrock_password_db }
  let(:private_key) { passrock_private_key }
  let(:init_opts) { {:password_db => password_db, :private_key => private_key} }
  let(:insecure_password) { 'password' }
  let(:secure_password) { 'BoatActKnowsDog' }

  describe '#secure?' do

    let(:subject) { described_class.new(init_opts) }

    context 'when given password is present in the password database' do
      it 'returns false' do
        expect(subject.secure?(insecure_password)).to be_false

        # sanity check other known insecure passwords
        [ 'inIUfiWO13', 'PVGWpkf81', 'cSAuOcUW58', 'XxPRBGF11', 'WjNYUmGj72', 'P0RQU33SM3N3ST3r' ].each do |password|
          expect(subject.secure?(password)).to be_false
        end
      end
    end

    context 'when given password does not appear in the password database' do
      it 'returns true' do
        expect(subject.secure?(secure_password)).to be_true
      end
    end

  end

  describe '#insecure?' do

    let(:subject) { described_class.new(init_opts) }

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

end
