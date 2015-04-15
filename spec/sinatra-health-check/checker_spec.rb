require 'spec_helper'

describe SinatraHealthCheck::Checker do

  describe '#init, default values' do
    its(:health) { should == true }
  end

  describe '#init, custom values' do
    subject { described_class.new(:timeout => 10, :health => false)}
    its(:health) { should == false }
  end

  context '#graceful_stop' do
    subject { described_class.new(:timeout => 12)}

    it 'gracefully stops the app' do
      # it's healthy before stopping
      expect(subject.health).to be_truthy

      expect(subject).to receive(:sleep).ordered.with(12) {
        if subject.healthy?
          puts 'health state should be false here'
          raise Error, 'health state should be false here'
        end
      }
      expect(subject).to receive(:exit).ordered
      subject.graceful_stop
      subject.join

      # it's unhealthy after stopping
      expect(subject.health).to be_falsey
    end
  end

  context '#graceful_stop, w/ :wait' do
    subject { described_class.new(:wait => 5)}

    it 'does not call exit' do
      expect(subject).to receive(:sleep).ordered.with(5)
      expect(subject).to receive(:sleep).ordered.with(10)
      expect(subject).to receive(:exit).ordered
      subject.graceful_stop
      subject.join
    end
  end

  context '#graceful_stop, w/o exit' do
    subject { described_class.new(:exit => false)}

    it 'does not call exit' do
      expect(subject).to receive(:sleep).with(10)
      expect(subject).not_to receive(:exit)
      subject.graceful_stop
      subject.join
    end
  end

end
