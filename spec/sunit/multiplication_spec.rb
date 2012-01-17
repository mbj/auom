require 'spec_helper'

describe SUnits::Unit do
  let(:unit_scalar)    { 10.to_r }
  let(:operand_scalar) { 4.to_r }

  shared_examples_for 'an invalid operation' do
    it 'should raise ArgumentError' do
      expect { subject }.to raise_error(ArgumentError)
    end
  end

  shared_examples_for 'an operation' do
    it 'should neturn a new object' do
      unit.object_id.should_not == subject.object_id
    end
   
    its(:scalar) { should be_kind_of(::Rational) }
  end

  [[:*,:multiplication],[:/,:division]].each do |symbol,name|
    describe "##{symbol} (#{name})" do
      subject do
        unit.send(symbol, operand)
      end
     
      shared_examples_for "a unit #{name}" do
        it_should_behave_like 'an operation'
     
        it "should calculate the correct scalar #{name}" do
          subject.scalar.should == unit_scalar.send(symbol,operand_scalar)
        end
      end
     
      context 'when unit is unitless' do
        let(:unit) { described_class.new(unit_scalar) }
     
        context 'and operand is a fixnum' do
          let(:operand) { operand_scalar }
     
          it_should_behave_like 'unitless unit'
          it_should_behave_like "a unit #{name}"
        end
     
        context 'and operand is a unit' do
          let(:operand) { described_class.new(operand_scalar,:kilogramm) }
     
          it 'should store units' do
            if symbol == :multiplication
              subject.unit.should == [[:kilogramm],[]]
            elsif symbol == :division
              subject.unit.should == [[],[:kilogram]]
            end
          end
     
          it_should_behave_like "a unit #{name}"
        end
     
        context 'and operand is a float' do
          let(:operand) { 1.5 }

          it_should_behave_like 'an invalid operation'
        end
      end
     
      context 'when unit is not unitless' do
        let(:unit) { described_class.new(unit_scalar,[:euro,:kilogramm],:meter) }
     
        context 'and operand is a fixnum' do
          let(:operand) { operand_scalar }
     
          it 'should create a non unitless unit' do
            subject.unit.should == [[:euro,:kilogramm],[:meter]]
          end
     
          it_should_behave_like "a unit #{name}"
        end
     
        context 'and operand is a unit' do
          let(:operand) { described_class.new(operand_scalar,:kilogramm,:euro) }
     
          it 'should eliminate as many units as possible' do
            if symbol == :multiplication
              subject.unit.should == [[:kilogramm,:kilogramm],[:meter]]
            elsif symbol == :division
              subject.unit.should == [[:euro,:euro],[:meter]]
            end
          end
     
          it_should_behave_like "a unit #{name}"
        end
      end
    end
  end

  [[:+,:addition],[:-,:substraction]].each do |symbol,name|
    describe "##{symbol} (#{name})" do
      subject do
        unit.send(symbol, operand)
      end
   
      shared_examples_for "a unit #{name}" do
        it_should_behave_like 'an operation'
   
        it 'should calculate the correct result' do
          subject.scalar.should == unit_scalar.send(symbol,operand_scalar)
        end
      end
   
      context 'when unit is unitless' do
        let(:unit) { described_class.new(unit_scalar) }
   
        context 'and operand is a Fixnum' do
          let(:operand) { operand_scalar }
   
          it_should_behave_like "a unit #{name}"
          it_should_behave_like 'unitless unit'
        end
   
        context 'and operand is a unitless unit' do
          let(:operand) { described_class.new(operand_scalar) }
   
          it_should_behave_like "a unit #{name}"
          it_should_behave_like 'unitless unit'
        end
   
        context 'and operand is not unitless' do
          let(:operand) { described_class.new(operand_scalar,:kilogramm) }
          it_should_behave_like 'an invalid operation'
        end
      end
   
      context 'when unit is not unitless' do
        let(:unit) { described_class.new(unit_scalar,:kilogramm) }
   
        context 'and operand is a Fixnum' do
          let(:operand) { operand_scalar }
          it_should_behave_like 'an invalid operation'
        end
   
        context 'and operand is a compatible unit' do
          let(:operand) { described_class.new(operand_scalar,:kilogramm) }
          it_should_behave_like "a unit #{name}"
   
          it 'should store the correct units' do
            subject.unit.should == [[:kilogramm],[]]
          end
        end
   
        context 'and operand is a incompatible unit' do
          let(:operand) { described_class.new(operand_scalar,:euro) }
          it_should_behave_like 'an invalid operation'
        end
      end
    end
  end
end
