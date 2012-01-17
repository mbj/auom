require 'spec_helper'

describe SUnits::Unit,'#to_hash' do
  let(:object) { described_class.new(*arguments) }

  subject { object.to_hash }

  context 'unitless unit' do
    let(:arguments) { [1] }
    
    it 'should return a hash with a scalar' do
      subject.should == { :scalar => [1,1], :value => 1 }
    end
  end

  context 'unit with numerator' do
    let(:arguments) { [1,:meter] }

    it 'should reutrn a hash with scalar and numerator' do
      subject.should == { :scalar => [1,1], :value => 1, :numerators => [:meter] }
    end
  end

  context 'unit with denominator' do
    let(:arguments) { [1,nil,:meter] }

    it 'should reutrn a hash with scalar and denominator' do
      subject.should == { :scalar => [1,1], :value => 1, :denominators => [:meter] }
    end
  end

  context 'unit with numerator and denominator' do
    let(:arguments) { [1,:meter,:kilogramm] }

    it 'should reutrn a hash with scalar and denominator' do
      subject.should == { :scalar => [1,1], :value => 1, :numerators => [:meter], :denominators => [:kilogramm] }
    end
  end

  context 'when value is not even dividable' do
    let(:arguments) { [[1,2],:meter] }
    it 'shoud dump a float as value' do
      subject[:value].should be_kind_of(Float)
    end
  end

  context 'when value is even dividable' do
    let(:arguments) { [1,:meter] }

    it 'shoud dump a interger value' do
      subject[:value].should be_kind_of(Integer)
    end
  end
end
