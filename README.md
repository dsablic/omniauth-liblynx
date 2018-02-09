# OmniAuth LibLynx Strategy &nbsp;[![Build Status](https://travis-ci.org/dsablic/omniauth-liblynx.svg?branch=master)](https://travis-ci.org/dsablic/omniauth-liblynx)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-liblynx'
```

## Usage

Adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :liblynx, ENV['LIBLYNX_ID'], ENV['LIBLYNX_SECRET']
end
```

Read the OmniAuth docs for detailed instructions: https://github.com/intridea/omniauth.
