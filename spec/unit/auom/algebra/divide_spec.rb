require 'spec_helper'

describe AUOM::Algebra,'#divide' do
  subject { object.divide(operand) }

  let(:object) { AUOM::Unit.new(*arguments) }

  context 'with unitless unit' do
    let(:arguments) { [2] }

    context 'when operand is a fixnum' do
      let(:operand) { 1 }

      it_should_behave_like 'an operation'

      it { should eql(AUOM::Unit.new(2)) }
    end

    context 'when operand is a unitless unit' do
      let(:operand) { AUOM::Unit.new(1) }

      it_should_behave_like 'an operation'

      it { should eql(AUOM::Unit.new(2)) }
    end

    context 'when operand is a unitful unit' do
      let(:operand) { AUOM::Unit.new(1,:meter) }

      it_should_behave_like 'an operation'

      it { should eql(AUOM::Unit.new(2,[],:meter)) }
    end
  end
  
  context 'with unitful unit' do
    let(:arguments) { [2,:meter] }

    context 'when operand is a fixnum' do
      let(:operand) { 1 }

      it_should_behave_like 'an operation'

      it { should eql(AUOM::Unit.new(2,:meter)) }
    end

    context 'when operand is a unitless unit' do
      let(:operand) { AUOM::Unit.new(1) }

      it_should_behave_like 'an operation'

      it { should eql(AUOM::Unit.new(2,:meter)) }
    end

    context 'when operand is a unitful unit' do

      context 'and units NOT cancle each other' do
        let(:operand) { AUOM::Unit.new(1,:euro) }

        it_should_behave_like 'an operation'

        it { should eql(AUOM::Unit.new(2,:meter,:euro)) }
      end

      context 'and untis cancle each other' do
        let(:operand) { AUOM::Unit.new(1,:meter) }

        it_should_behave_like 'an operation'

        it { should eql(AUOM::Unit.new(2)) }
      end
    end
  end
end
