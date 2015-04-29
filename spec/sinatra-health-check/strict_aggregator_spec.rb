require 'spec_helper'

describe SinatraHealthCheck::Status::StrictAggregator do

  context '#aggregate' do

    ONE = SinatraHealthCheck::Status.new(:error, 'foo')
    TWO = SinatraHealthCheck::Status.new(:warning, 'bar')
    THREE = SinatraHealthCheck::Status.new(:ok, 'foobar')

    it 'aggregates {} to :ok' do
      expect(subject.aggregate({}).level).to eq(:ok)
    end

    it 'aggregates to :ok when one status is :ok' do
      statuus = {
        :one => ONE,
        :two => TWO,
        :three => THREE,
      }
      expect(subject.aggregate(statuus).level).to eq(:error)
    end

    it 'aggregates to :warning when one status is :warning' do
      statuus = {
        :two => TWO,
        :three => THREE,
      }
      expect(subject.aggregate(statuus).level).to eq(:warning)
    end

    it 'aggregates to :error when all status are :error' do
      statuus = {
        :three => THREE,
      }
      expect(subject.aggregate(statuus).level).to eq(:ok)
    end

    it 'aggregates details' do
      statuus = {
        :one => ONE,
        :two => TWO,
      }
      expect(subject.aggregate(statuus).to_h[:statusDetails]).to eq({
        :one => {
          :status => 'ERROR',
          :message => 'foo',
        },
        :two => {
          :status => 'WARNING',
          :message => 'bar',
        },
      })
    end
  end

end
