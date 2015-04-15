# The application health check.
# Create an instance and use .health to repond to your health check requests.
class SinatraHealthCheck::Checker

  DEFAULT_OPTS = {
    :exit    => true,
    :health  => true,
    :logger  => nil,
    :signals => %w[TERM INT],
    :timeout => 10,
    :wait    => 0,
  }

  require 'thread'

  attr_accessor :health
  alias :healthy? :health

  # Create a health checker.
  # Params:
  # ++exit++: call ++exit++ at the end of ++graceful_stop++
  # ++health++: initial health state
  # ++logger++: a logger
  # ++signals++: array of signals to register a graceful stop handler
  # ++timeout++: timeout for graceful stop in seconds
  def initialize(opts = DEFAULT_OPTS)
    @opts = DEFAULT_OPTS.merge(opts)
    @health = @opts[:health]
    trap(@opts[:signals])
  end

  # Set application to unhealthy state and stop it after wating for ++@timeout++.
  def graceful_stop
    # set to unhealthy state
    unless @stopper
      # spawn a thread to stop application after a given time
      @stopper = Thread.new do
        if @opts[:wait] > 0
          logger.info "asked to stop application, waiting for #{@opts[:wait]}s before doing so" if logger
          sleep @opts[:wait]
        end
        logger.info "stopping application, waiting for #{@opts[:timeout]}s" if logger
        @health = false
        sleep @opts[:timeout]
        logger.info "exit application" if logger
        exit if @opts[:exit]
      end
    end
  end

  # Waits for the stopping thread to finish
  def join
    @stopper.join if @stopper
  end

  private

  def logger
    @opts[:logger]
  end

  # Register signal handler to stop application gracefully.
  # Params:
  # ++signals++: array of signal names
  def trap(signals)
    if signals and signals.size > 0
      logger.info "register graceful stop handler for signals: #{signals.join(', ')}" if logger
      signals.each do |sig|
        Signal.trap(sig) { graceful_stop }
      end
    end
  end
end
