require 'base64'
require 'bcrypt'

module Passrock
  class PasswordDbFinder

    RECORD_LENGTH = 12


    def self.bcrypt_hash(secret, salt)
      BCrypt::Engine.hash_secret(secret, "$2a$07$#{salt}")
    end


    attr_reader :password_db, :private_key

    def initialize(opts = {})
      @password_db = opts[:password_db]
      @private_key = opts[:private_key]
    end

    def valid?
      password_db_is_a_file? || password_db_is_a_directory?
    end

    def find(password)
      raise PasswordDbNotFoundError, "Passrock Password DB not found at: #{password_db}" unless valid?
      find_by_binary_search(password)
    end

    def filename(hashed_password = nil)
      return password_db if password_db_is_a_file?
      File.join(password_db, "PRbinary#{hashed_password.ord}.dat")
    end

    def password_db_is_a_file?
      File.file?(password_db)
    end

    def password_db_is_a_directory?
      File.directory?(password_db)
    end


    private

    def password_in_searchable_form(password)
      password = password.to_s.downcase
      hashed_password = self.class.bcrypt_hash(password, private_key)

      searchable = hashed_password[29..-1]
      searchable.tr!('./ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789', 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/')
      searchable += '=' * (3 - (searchable.size + 3) % 4)
      searchable[0, 16]
    end

    def find_by_binary_search(password)
      target = password_in_searchable_form(password)
      file = File.new(filename(target), 'rb')
      total_records = (File.size(file) / RECORD_LENGTH) - 1

      lo = 0
      hi = total_records
      while lo <= hi
        mid = (lo + (hi - lo) / 2)
        file.seek(RECORD_LENGTH * mid, IO::SEEK_SET)
        midtest = file.read(RECORD_LENGTH)
        raise BinaryFileReadError if midtest.nil?

        midtest = Base64.strict_encode64(midtest)

        if ( (midtest <=> target) == 0 )
          file.close
          return target
        elsif ( (midtest <=> target) < 0 )
          lo = mid + 1
        else
          hi = mid - 1
        end
      end

      file.close
      return nil
    end

  end
end