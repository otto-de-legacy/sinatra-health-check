sinatra-health-check
====================

[![Gem Version](https://badge.fury.io/rb/sinatra-health-check.svg)](http://badge.fury.io/rb/sinatra-health-check) [![travis-ci](https://travis-ci.org/otto-de/sinatra-health-check.png?branch=master)](https://travis-ci.org/otto-de/sinatra-health-check) [![Code Climate](https://codeclimate.com/github/otto-de/sinatra-health-check/badges/gpa.svg)](https://codeclimate.com/github/otto-de/sinatra-health-check) [![Test Coverage](https://codeclimate.com/github/otto-de/sinatra-health-check/badges/coverage.svg)](https://codeclimate.com/github/otto-de/sinatra-health-check)

This tiny gem adds graceful stop to your sinatra application.

Stopping apps gracefully allows your running requests to finish before killing the app. It gives some time to configure load balancers before shutting things down.

Usage
-----

Initialize the health check:

```ruby
require 'sinatra-health-check'
@checker = SinatraHealthCheck::Checker.new
```

Then use it inside your health check route:

```ruby
get "/ping" do
  if @checker.healthy?
    "pong"
  else
    status 503
    "unhealthy"
  end
end
```

Contributing
------------

It's fast and simple: fork + PR.

License
-------

This program is licensed under the MIT license. See LICENSE for details.
