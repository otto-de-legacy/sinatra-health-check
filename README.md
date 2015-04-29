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

Optionally add subsystems to the Checker:

```ruby
# mysubsystem responds to :status with a SinatraHealthCheck::Status object
@checker.systems[:mysubsystem] = mysubsystem
```

Then use it inside your health check route:

```ruby
get "/internal/health" do
  if @checker.healthy?
    "healthy"
  else
    status 503
    "unhealthy"
  end
end
```

Deliver a status document showing overall health/status and status of all subsystems:

```ruby
get "/internal/status" do
  headers 'content-type' => 'application/json'
  @checker.status.to_json
end
```

Contributing
------------

It's fast and simple: fork + PR.

License
-------

This program is licensed under the MIT license. See LICENSE for details.
