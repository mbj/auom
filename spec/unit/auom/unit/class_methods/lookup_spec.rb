require 'spec_helper'

describe AUOM::Unit, '.lookup' do
  subject { object.send(:lookup, value) }

  let(:object) { described_class }

  context 'with existing symbol' do
    let(:value) { :meter }

    it { should eql([1, :meter]) }
  end

  context 'with inexisting symbol' do
    let(:value) { :foo }

    it 'should raise error' do
      expect { subject }.to raise_error(ArgumentError, 'Unknown unit :foo')
    end
  end
end
