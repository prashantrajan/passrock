module Passrock
  class PasswordDb

    attr_reader :password_db_finder

    def initialize(opts = {})
      @password_db_finder = PasswordDbFinder.new(opts)
    end

    def secure?(password)
      !password_db_finder.find(password)
    end

    def insecure?(password)
      !secure?(password)
    end

  end
end