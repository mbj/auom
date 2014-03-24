require 'spec_helper'

describe AUOM::Algebra, '#substract' do
  subject { object.substract(operand) }

  let(:object) { AUOM::Unit.new(*arguments) }

  context 'when unit is unitless' do
    let(:arguments) { [1] }

    context 'and operand is a Fixnum' do
      let(:operand) { 1 }

      it_should_behave_like 'an operation'

      it { should eql(AUOM::Unit.new(0)) }
    end

    context 'and operand is a unitless unit' do
      let(:operand) { AUOM::Unit.new(1) }

      it { should eql(AUOM::Unit.new(0)) }
    end

    context 'and operand is a unitful unit' do
      let(:operand) { AUOM::Unit.new(1, :meter) }

      it_should_behave_like 'an incompatible operation'
    end
  end

  context 'when unit is unitful' do
    let(:arguments) { [1, :meter] }

    context 'and operand is a Fixnum' do
      let(:operand) { 1 }

      it_should_behave_like 'an incompatible operation'
    end

    context 'and operand is a unitless unit' do
      let(:operand) { AUOM::Unit.new(1) }

      it_should_behave_like 'an incompatible operation'
    end

    context 'and operand is a incompatible unit' do
      let(:operand) { AUOM::Unit.new(1, :euro) }

      it_should_behave_like 'an incompatible operation'
    end

    context 'and operand is a compatible unit' do
      let(:operand) { AUOM::Unit.new(1, :meter) }

      it { should eql(AUOM::Unit.new(0, :meter)) }
    end
  end
end
