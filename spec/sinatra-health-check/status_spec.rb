require 'spec_helper'

describe SinatraHealthCheck::Status do

  describe '#init' do
    subject { described_class.new(:ok, 'fooo')}
    its(:level) { should == :ok }
    its(:message) { should == 'fooo' }
    its(:to_i) { should == 0 }
    its(:to_h) { should == { :status => 'OK', :message => 'fooo' } }
    its(:to_json) { should == { :status => 'OK', :message => 'fooo' }.to_json }
  end

end
