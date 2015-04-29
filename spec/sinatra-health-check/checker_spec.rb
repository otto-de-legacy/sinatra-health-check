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

  context '#status' do
    it 'has a status' do
      expect(subject.status.level).to eq(:ok)
      expect(subject.healthy?).to be_truthy
      expect(subject.status.to_h[:statusDetails]).to be_nil
    end

    it 'has substatus' do
      substatus = SinatraHealthCheck::Status.new(:ok, 'sub is ok')
      system = double("System", :status => substatus)
      subject.systems[:sub] = system
      expect(subject.status.level).to eq(:ok)
      expect(subject.healthy?).to be_truthy
      expect(subject.status.to_h[:statusDetails][:sub]).to eq(substatus.to_h)
    end

    it 'is unhealthy with unhealthy subsystem' do
      substatus = SinatraHealthCheck::Status.new(:error, 'unhealthy')
      system = double("System", :status => substatus)
      subject.systems[:sub] = system
      expect(subject.status.level).to eq(:error)
      expect(subject.healthy?).to be_falsey
    end
  end

end
