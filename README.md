# OmniAuth LibLynx Strategy &nbsp;[![Release](https://github.com/dsablic/omniauth-liblynx/actions/workflows/release.yml/badge.svg)](https://github.com/dsablic/omniauth-liblynx/actions/workflows/release.yml) [![Gem Version](https://badge.fury.io/rb/omniauth-liblynx.svg)](https://badge.fury.io/rb/omniauth-liblynx)

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

## Releasing

1. Bump the version in `lib/omniauth-liblynx/version.rb`
2. Commit: `git commit -am "Bump version to X.Y.Z"`
3. Tag: `git tag vX.Y.Z`
4. Push: `git push origin master --tags`

The GitHub Actions release workflow will build and publish the gem to RubyGems automatically.

> **Note:** RubyGems trusted publishing must be configured for this repo on rubygems.org before the first release. Under the gem's settings on rubygems.org, add a trusted publisher with owner `dsablic`, repository `omniauth-liblynx`, workflow `release.yml`, and environment `rubygems`.
