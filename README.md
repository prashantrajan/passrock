# Passrock

[![Gem Version](https://badge.fury.io/rb/passrock.png)](http://badge.fury.io/rb/passrock)
[![Code Climate](https://codeclimate.com/github/bitium/passrock.png)](https://codeclimate.com/github/bitium/passrock)

Ruby client library for programmatic access to the [Passrock Binary Database](https://www.passrock.com/demo.php).

This library adheres to [SemVer](http://semver.org). Pre v1.0.0 is considered alpha level software.


## Installation

Add this line to your application's Gemfile:

    gem 'passrock'

And then execute:

    $ bundle


## Usage

### Plain Ol' Ruby (PORO)

```ruby
require 'passrock'

passrock_db = Passrock::PasswordDb.new(:password_db => '/path/to/passrock_db_dir', :private_key => 'your private key')
passrock_db.secure?('password') # => false
passrock_db.insecure?('PASSWORD') # => true
```

### Ruby on Rails

This library provides a custom ActiveModel validation:

```ruby
# Configure: config/initializers/passrock.rb
Passrock.configure do |config|
  config.password_db = '/path/to/passrock_db_dir'
  config.private_key = 'your private key'
end

# Model
# e.g. app/models/user.rb
validates :password, :passrock_secure => true
```

```yaml
# Customize the error message (see: http://guides.rubyonrails.org/i18n.html#error-message-scopes)
# e.g. config/locales/en.yml
activerecord:
  errors:
    messages:
      passrock_secure: "appears to be a commonly used password"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Specs

To run the spec suite:

      bundle install
      cp .env.example .env # and change the env values
      bundle exec rake spec
