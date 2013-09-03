# Passrock

Ruby client library for programmatic access to the [Passrock Binary Database](https://www.passrock.com/demo.php).


## Installation

Add this line to your application's Gemfile:

    gem 'passrock'

And then execute:

    $ bundle


## Usage

### Plain Ol' Ruby (PORO)

      require 'passrock'

      passrock_db = Passrock::PasswordDb.new('/path/to/passrock/binary.dat', 'your private key')
      passrock_db.secure?('password') # => false
      passrock_db.insecure?('av3r^securePass') # => false


### Ruby on Rails

This library provides a custom ActiveModel validation:

      # Configure: config/initializers/passrock.rb
      Passrock.configure do |config|
        config.password_db = '/path/to/passrock/binary.dat'
        config.private_key = 'your private key'
      end

      # Model
      # e.g. app/models/user.rb
      validates :password, :passrock_secure => true

      # Customize the error message (see: http://guides.rubyonrails.org/i18n.html#error-message-scopes)
      # e.g. config/locales/en.yml
      activerecord:
        errors:
          messages:
            passrock_secure: "appears to be a commonly used password"


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


# Specs

To run the spec suite:

      bundle install
      cp .env.example .env # and change the env values
      bundle exec rake spec
