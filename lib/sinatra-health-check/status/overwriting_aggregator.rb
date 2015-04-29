# Aggregate statuus with an aggregator but allow overwriting :level and :message.
class SinatraHealthCheck::Status::OverwritingAggregator
  def initialize(aggregator)
    raise ArgumentError, 'aggregator must respond to .aggregate' unless aggregator.respond_to?(:aggregate)
    @aggregator = aggregator
  end

  # aggregate statuus with given aggregator, but overwrite :status and :message if overwrite is given too
  def aggregate(statuus, overwrite = nil)
    if overwrite
      SinatraHealthCheck::Status::Aggregated.new(overwrite.level, overwrite.message, statuus)
    else
      @aggregator.aggregate(statuus)
    end
  end
end
