# Aggregate sub statuus, best wins
class SinatraHealthCheck::Status::ForgivingAggregator
  def aggregate(statuus)
    status = statuus.values.min_by { |s| s.to_i } || SinatraHealthCheck::Status.new(:ok, 'everything is fine')
    message = status.level == :ok ? 'everything is fine' : "all statuus are at least #{status.level}"

    SinatraHealthCheck::Status::Aggregated.new(status.level, message, statuus)
  end
end
