# frozen_string_literal: true

describe AUOM::Algebra do
  describe '#add' do
    subject { object.add(operand) }

    let(:object) { AUOM::Unit.new(*arguments) }

    context 'when unit is unitless' do
      let(:arguments) { [1] }

      context 'and operand is an Integer' do
        let(:operand) { 2 }

        it_should_behave_like 'an operation'

        it { should eql(AUOM::Unit.new(3)) }
      end

      context 'and operand is a unitless unit' do
        let(:operand) { AUOM::Unit.new(2) }

        it { should eql(AUOM::Unit.new(3)) }
      end

      context 'and operand is a unitful unit' do
        let(:operand) { AUOM::Unit.new(2, :meter) }

        it_should_behave_like 'an incompatible operation'
      end
    end

    context 'when unit is unitful' do
      let(:arguments) { [1, :meter, :euro] }

      context 'and operand is an Integer' do
        let(:operand) { 2 }

        it_should_behave_like 'an incompatible operation'
      end

      context 'and operand is a unitless unit' do
        let(:operand) { AUOM::Unit.new(2) }

        it_should_behave_like 'an incompatible operation'
      end

      context 'and operand is a incompatible unit' do
        let(:operand) { AUOM::Unit.new(2, :euro) }

        it_should_behave_like 'an incompatible operation'
      end

      context 'and operand is a compatible unit' do
        let(:operand) { AUOM::Unit.new(2, :meter, :euro) }

        it { should eql(AUOM::Unit.new(3, :meter, :euro)) }
      end
    end
  end

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

  describe '#multiply' do
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

  describe '#subtract' do
    subject { object.subtract(operand) }

    let(:object) { AUOM::Unit.new(*arguments) }

    context 'when unit is unitless' do
      let(:arguments) { [1] }

      context 'and operand is an Integer' do
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

      context 'and operand is an Integer' do
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
end
