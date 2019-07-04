[![Build Status](https://travis-ci.org/mumuki/mumukit-platform.svg?branch=master)](https://travis-ci.org/mumuki/mumukit-platform)
[![Code Climate](https://codeclimate.com/github/mumuki/mumukit-platform/badges/gpa.svg)](https://codeclimate.com/github/mumuki/mumukit-platform)
[![Test Coverage](https://codeclimate.com/github/mumuki/mumukit-platform/badges/coverage.svg)](https://codeclimate.com/github/mumuki/mumukit-platform)
[![Issue Count](https://codeclimate.com/github/mumuki/mumukit-platform/badges/issue_count.svg)](https://codeclimate.com/github/mumuki/mumukit-platform)

# Mumukit::Platform

> Generic components for building Mumuki Platform applications

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mumukit-platform'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mumukit-platform

## Requeriments

In order to properly use this gem, you must declare _organization_, _course_ and _user_ classes, and implement some required methods:

 _organization_:
   * `#name`
   * `#locale`
   * `.find_by_name!`

 _user_:
   * `.find_by_uid!`

 _course_:
   * `.find_by_slug!`


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mumuki/mumukit-platform. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
