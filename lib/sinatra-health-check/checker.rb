# The application health check.
# Create an instance and use .health to repond to your health check requests.
class SinatraHealthCheck::Checker

  DEFAULT_OPTS = {
    :aggregator => SinatraHealthCheck::Status::StrictAggregator.new,
    :exit       => true,
    :health     => true,
    :logger     => nil,
    :signals    => %w[TERM INT],
    :systems    => {},
    :timeout    => 10,
    :wait       => 0,
  }

  require 'thread'

  attr_accessor :health
  attr_reader :systems

  # Create a health checker.
  # Params:
  # ++aggrgator++: an aggregator for substatuus, default: StrictAggregator
  # ++exit++: call ++exit++ at the end of ++graceful_stop++
  # ++health++: initial health state
  # ++logger++: a logger
  # ++signals++: array of signals to register a graceful stop handler
  # ++systems++: a hash of subsystems responding to .status
  # ++timeout++: timeout for graceful stop in seconds
  # ++wait++: wait before setting health to unhealthy
  def initialize(opts = {})
    @opts = DEFAULT_OPTS.merge(opts)
    @aggregator = SinatraHealthCheck::Status::OverwritingAggregator.new(@opts[:aggregator])
    @health = @opts[:health]
    @systems = @opts[:systems]
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

  # Returns a Status object
  def status
    statuus = {}
    systems.each { |k,v| statuus[k] = v.status if v.respond_to?(:status) }
    @aggregator.aggregate(statuus, health ? nil : SinatraHealthCheck::Status.new(:error, 'app is unhealthy'))
  end

  def healthy?
    status.level != :error
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
