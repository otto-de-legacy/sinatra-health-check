# Application status definition with subsystems
class SinatraHealthCheck::Status::Aggregated < SinatraHealthCheck::Status

  attr_reader :statuus

  def initialize(level, message, statuus, extras = {})
    raise ArgumentError, "statuus must be a hash of SinatraHealthCheck::Status, but is #{statuus.class}" \
      unless statuus.is_a?(Hash)
    super(level, message, { :statusDetails => statuus }.merge(extras))
  end

  def to_h
    subs = {}
    extras[:statusDetails].each { |k,v| subs[k] = v.to_h }

    s = extras.merge({
      :status  => level.to_s.upcase,
      :message => message,
      :statusDetails => subs
    })
    s.delete(:statusDetails) if s[:statusDetails].size == 0
    s
  end
end
