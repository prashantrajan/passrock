module Passrock

  class PassrockError < ::StandardError; end

  class PasswordDbNotFoundError < PassrockError; end
  class PrivateKeyInvalidError < PassrockError; end

end
