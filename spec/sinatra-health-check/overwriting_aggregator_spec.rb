require 'spec_helper'

describe SinatraHealthCheck::Status::OverwritingAggregator do

  context '#aggregate' do
    aggregator = SinatraHealthCheck::Status::ForgivingAggregator.new
    subject { described_class.new(aggregator) }

    it 'overwrites the status' do
      expect(aggregator).not_to receive(:aggregate)
      expect(subject.aggregate({}, SinatraHealthCheck::Status.new(:error, 'foo')).level).to eq(:error)
    end

    it 'does not overwrite the status' do
      expect(aggregator).to receive(:aggregate) { :foo }
      expect(subject.aggregate({})).to eq(:foo)
    end
  end

end
