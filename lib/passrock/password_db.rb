require 'base64'
require 'bcrypt'

module Passrock
  class PasswordDb

    RECORD_LENGTH = 23


    def self.bcrypt_hash(secret, salt)
      BCrypt::Engine.hash_secret(secret, "$2a$07$#{salt}")
    end


    attr_reader :filename, :private_key

    def initialize(filename, private_key)
      @filename = filename
      @private_key = private_key
    end

    def password_in_searchable_form(password)
      hashed_password = self.class.bcrypt_hash(password, private_key)

      searchable = hashed_password[29..-1]
      searchable.tr!('./ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789', 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/')
      searchable += '=' * (3 - (searchable.size + 3) % 4)
    end

    def secure?(password)
      !find_by_binary_search(password)
    end

    def insecure?(password)
      !secure?(password)
    end


    private

    def total_records
      # Minus 1 for length in file and 1 for 0-up counting
      @total_records ||= (File.size(filename) / RECORD_LENGTH) - 2
    end

    def find_by_binary_search(password)
      file = File.new(filename, 'rb')
      target = password_in_searchable_form(password)

      lo = 1 # start at 1 because the testKey is at 0
      hi = total_records
      while lo <= hi
        mid = (lo + (hi - lo) / 2)
        file.seek(RECORD_LENGTH * mid, IO::SEEK_SET)
        midtest = file.read(RECORD_LENGTH)
        raise 'Error reading binary file' if midtest.nil?

        midtest = Base64.strict_encode64(midtest)

        if ( (midtest <=> target) == 0 )
          file.close
          return true
        elsif ( (midtest <=> target) < 0 )
          lo = mid + 1
        else
          hi = mid - 1
        end
      end

      file.close
      return false
    end

  end
end