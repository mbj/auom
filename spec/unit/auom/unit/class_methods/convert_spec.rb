require 'spec_helper'

describe AUOM::Unit, '.convert' do
  subject { object.convert(value) }

  let(:object) { AUOM::Unit }

  context 'with nil' do
    let(:value) { nil }

    it 'should raise error' do
      expect { subject }.to raise_error(ArgumentError, 'Cannot convert nil to AUOM::Unit')
    end
  end

  context 'with fixnum' do
    let(:value) { 1 }

    it { should eql(AUOM::Unit.new(1)) }
  end

  context 'with rational' do
    let(:value) { Rational(2, 1) }

    it { should eql(AUOM::Unit.new(2)) }
  end

  context 'with Object' do
    let(:value) { Object.new }

    it 'should raise error' do
      expect { subject }.to raise_error(ArgumentError, "Cannot convert #{value.inspect} to AUOM::Unit")
    end
  end
end
