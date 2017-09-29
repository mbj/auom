require 'spec_helper'

describe AUOM::Algebra, '#multiply' do
  subject { object.multiply(operand) }

  let(:object) { AUOM::Unit.new(*arguments) }

  context 'with unitless unit' do
    let(:arguments) { [2] }

    context 'when operand is a fixnum' do
      let(:operand) { 3 }

      it_should_behave_like 'an operation'

      it { should eql(AUOM::Unit.new(6)) }
    end

    context 'when operand is a unitless unit' do
      let(:operand) { AUOM::Unit.new(3) }

      it_should_behave_like 'an operation'

      it { should eql(AUOM::Unit.new(6)) }
    end

    context 'when operand is a unitful unit' do
      let(:operand) { AUOM::Unit.new(3, :meter) }

      it_should_behave_like 'an operation'

      it { should eql(AUOM::Unit.new(6, :meter)) }
    end
  end

  context 'with unitful unit' do
    let(:arguments) { [2, :meter, :kilogramm] }

    context 'when operand is a fixnum' do
      let(:operand) { 3 }

      it_should_behave_like 'an operation'

      it { should eql(AUOM::Unit.new(6, :meter, :kilogramm)) }
    end

    context 'when operand is a unitless unit' do
      let(:operand) { AUOM::Unit.new(3) }

      it_should_behave_like 'an operation'

      it { should eql(AUOM::Unit.new(6, :meter, :kilogramm)) }
    end

    context 'when operand is a unitful unit' do

      context 'and units get added to numerator' do
        let(:operand) { AUOM::Unit.new(3, :meter) }

        it_should_behave_like 'an operation'

        it { should eql(AUOM::Unit.new(6, %i[meter meter], :kilogramm)) }
      end

      context 'and units get added to denominator' do
        let(:operand) { AUOM::Unit.new(3, [], :euro) }

        it_should_behave_like 'an operation'

        it { should eql(AUOM::Unit.new(6, :meter, %i[euro kilogramm])) }
      end

      context 'and units cancel each other' do
        let(:operand) { AUOM::Unit.new(3, [], :meter) }

        it_should_behave_like 'an operation'

        it { should eql(AUOM::Unit.new(6, [], :kilogramm)) }
      end
    end
  end
end
