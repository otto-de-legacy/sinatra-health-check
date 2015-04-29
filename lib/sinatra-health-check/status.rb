# Application status definition
class SinatraHealthCheck::Status

  SEVERITIES = {
    :ok      => 0,
    :warning => 1,
    :error   => 2,
  }

  attr_reader :level, :message, :extras

  def initialize(level, message, extras = {})
    raise ArgumentError, "level must be one of #{SEVERITIES.keys.join(', ')}, but is #{level}" unless SEVERITIES[level]
    raise ArgumentError, "message must not be nil" unless message
    raise ArgumentError, "extras must be a hash, but is #{extras.class}" unless extras.is_a?(Hash)

    @level = level
    @message = message
    @extras = extras
  end

  def to_i
    SEVERITIES[level]
  end
  alias :severity :to_i

  def to_h
    {
      :status  => level.to_s.upcase,
      :message => message,
    }.merge(extras)
  end

  def to_json
    to_h.to_json
  end
end
