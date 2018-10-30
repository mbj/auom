# frozen_string_literal: true

describe AUOM::Algebra do
  describe '#divide' do
    subject { object.divide(operand) }

    let(:object) { AUOM::Unit.new(*arguments) }

    context 'with unitless unit' do
      let(:arguments) { [4] }

      context 'when operand is a fixnum' do
        let(:operand) { 2 }

        it_should_behave_like 'an operation'

        it { should eql(AUOM::Unit.new(2)) }
      end

      context 'when operand is a unitless unit' do
        let(:operand) { AUOM::Unit.new(2) }

        it_should_behave_like 'an operation'

        it { should eql(AUOM::Unit.new(2)) }
      end

      context 'when operand is a unitful unit' do
        let(:operand) { AUOM::Unit.new(2, :meter) }

        it_should_behave_like 'an operation'

        it { should eql(AUOM::Unit.new(2, [], :meter)) }
      end
    end

    context 'with unitful unit' do
      let(:arguments) { [2, :meter] }

      context 'when operand is a fixnum' do
        let(:operand) { 1 }

        it_should_behave_like 'an operation'

        it { should eql(AUOM::Unit.new(2, :meter)) }
      end

      context 'when operand is a unitless unit' do
        let(:operand) { AUOM::Unit.new(1) }

        it_should_behave_like 'an operation'

        it { should eql(AUOM::Unit.new(2, :meter)) }
      end

      context 'when operand is a unitful unit' do
        context 'and units get added to denominator' do
          let(:operand) { AUOM::Unit.new(1, :euro) }

          it_should_behave_like 'an operation'

          it { should eql(AUOM::Unit.new(2, :meter, :euro)) }
        end

        context 'and units get added to numerator' do
          let(:operand) { AUOM::Unit.new(1, nil, :euro) }

          it_should_behave_like 'an operation'

          it { should eql(AUOM::Unit.new(2, %i[euro meter])) }
        end

        context 'and units cancel each other' do
          let(:operand) { AUOM::Unit.new(1, :meter) }

          it_should_behave_like 'an operation'

          it { should eql(AUOM::Unit.new(2)) }
        end
      end
    end
  end
end
