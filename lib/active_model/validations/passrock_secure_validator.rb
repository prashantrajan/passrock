require 'active_model/validations'

module ActiveModel
  module Validations

    class PassrockSecureValidator < ActiveModel::EachValidator

      def validate_each(record, attribute, value)
        passrock_db = Passrock::PasswordDb.new(:password_db => Passrock.configuration.password_db, :private_key => Passrock.configuration.private_key)
        record.errors.add(attribute, :passrock_secure) if passrock_db.insecure?(value)
      end

    end

  end
end
