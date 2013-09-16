module Passrock

  class PassrockError < ::StandardError; end

  class PasswordDbNotFoundError < PassrockError; end
  class BinaryFileReadError < PassrockError; end

end
