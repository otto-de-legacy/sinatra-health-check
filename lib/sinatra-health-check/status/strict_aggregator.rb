# Aggregate sub statuus, worst wins
class SinatraHealthCheck::Status::StrictAggregator
  def aggregate(statuus)
    status = statuus.values.max_by { |s| s.to_i } || SinatraHealthCheck::Status.new(:ok, 'everything is fine')
    message = status.level == :ok ? 'everything is fine' : "at least one status is #{status.level}"

    SinatraHealthCheck::Status::Aggregated.new(status.level, message, statuus)
  end
end
