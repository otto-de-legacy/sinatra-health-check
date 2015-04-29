module SinatraHealthCheck
  require_relative 'sinatra-health-check/version'
  require_relative 'sinatra-health-check/status'
  require_relative 'sinatra-health-check/status/aggregated'
  require_relative 'sinatra-health-check/status/overwriting_aggregator'
  require_relative 'sinatra-health-check/status/forgiving_aggregator'
  require_relative 'sinatra-health-check/status/strict_aggregator'
  require_relative 'sinatra-health-check/checker'
end
