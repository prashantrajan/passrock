module Passrock
  class PasswordDb

    attr_reader :password_db_file

    def initialize(opts = {})
      @password_db_file = PasswordDbFile.new(opts)
    end

    def secure?(password)
      !password_db_file.search(password)
    end

    def insecure?(password)
      !secure?(password)
    end

  end
end