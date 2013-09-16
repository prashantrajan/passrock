module Passrock

  class PassrockError < ::StandardError; end

  #class PasswordDbFileNotFoundError < PassrockError; end
  class PasswordDbDirNotFoundError < PassrockError; end
  class PrivateKeyInvalidError < PassrockError; end
  class BinaryFileReadError < PassrockError; end

end
