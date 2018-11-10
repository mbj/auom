# frozen_string_literal: true

describe AUOM do
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

  describe AUOM::Equalization, '#==' do
    subject { object == other }

    let(:object) { AUOM::Unit.new(1, :meter) }

    context 'when is other kind of object' do
      context 'that cannot be converted' do
        let(:other) { Object.new }

        it { should be(false) }
      end

      context 'that can be converted' do
        let(:other) { 1 }

        context 'and does not have the same values' do
          it { should be(false) }
        end

        context 'and does have the same values' do
          let(:other) { 1 }
          let(:object) { AUOM::Unit.new(1) }
          it { should be(true) }
        end
      end
    end

    context 'when is same kind of object' do
      let(:other) { AUOM::Unit.new(scalar, *unit) }

      let(:scalar) { 1 }
      let(:unit) { [:meter] }

      context 'and scalar and unit are the same' do
        it { should be(true) }
      end

      context 'and scalar is different' do
        let(:scalar) { 2 }
        it { should be(false) }
      end

      context 'and unit is different' do
        let(:unit) { [:euro] }
        it { should be(false) }
      end

      context 'and scalar and unit is different' do
        let(:scalar) { 2 }
        let(:unit) { [:euro] }
        it { should be(false) }
      end
    end
  end

  describe AUOM::Inspection do
    describe '#inspect' do
      subject { object.inspect }

      let(:object) { AUOM::Unit.new(scalar, *unit) }
      let(:unit) { [] }

      context 'when scalar is exact in decimal' do
        let(:scalar) { 1 }

        it { should eql('<AUOM::Unit @scalar=1>') }
      end

      context 'when scalar is NOT exact in decimal' do
        let(:scalar) { Rational(1, 2) }

        it { should eql('<AUOM::Unit @scalar=~0.5000>') }
      end

      context 'when has only numerator' do
        let(:scalar) { Rational(1, 3) }
        let(:unit) { [:meter] }

        it { should eql('<AUOM::Unit @scalar=~0.3333 meter>') }
      end

      context 'when has only denominator' do
        let(:scalar) { Rational(1, 3) }
        let(:unit) { [[], :meter] }

        it { should eql('<AUOM::Unit @scalar=~0.3333 1/meter>') }
      end

      context 'when has numerator and denominator' do
        let(:scalar) { Rational(1, 3) }
        let(:unit)   { %i[euro meter] }

        it { should eql('<AUOM::Unit @scalar=~0.3333 euro/meter>') }
      end
    end

    describe '.prettify_unit_part' do
      subject { object.prettify_unit_part(part) }

      let(:object) { AUOM::Inspection }

      context 'with simple part' do
        let(:part) { [:meter] }

        it { should eql('meter') }
      end

      context 'with mixed part' do
        let(:part) { %i[meter euro] }

        it { should eql('euro*meter') }
      end

      context 'with complex part' do
        let(:part) { %i[meter meter euro] }

        it { should eql('meter^2*euro') }
      end

      context 'with very complex part' do
        let(:part) { %i[meter meter euro euro kilogramm] }

        it { should eql('euro^2*meter^2*kilogramm') }
      end
    end
  end

  describe AUOM::Relational do
    describe '#<=>' do
      subject { object <=> other }

      let(:object) { AUOM::Unit.new(1, :meter)    }
      let(:other)  { AUOM::Unit.new(scalar, unit) }

      context 'when operand unit is the same' do
        let(:unit) { :meter }

        context 'and operand scalar is less than receiver scalar' do
          let(:scalar) { 0 }

          it { should be(1) }
        end

        context 'and operand scalar is equal to receiver scalar' do
          let(:scalar) { 1 }

          it { should be(0) }
        end

        context 'and operand scalar is greater than receiver scalar' do
          let(:scalar) { 2 }

          it { should be(-1) }
        end
      end

      context 'when operand unit is not the same' do
        let(:scalar) { 1     }
        let(:unit)   { :euro }

        it_should_behave_like 'an incompatible operation'
      end
    end

    describe 'Comparable inclusion' do
      specify do
        expect(AUOM::Unit < Comparable).to be(true)
      end
    end
  end

  describe AUOM::Unit do
    describe '#assert_same_unit' do
      subject { object.assert_same_unit(other) }

      let(:object) { described_class.new(1, *unit) }
      let(:unit)   { [%i[meter], %i[euro]]         }

      context 'when units are the same' do
        let(:other) { AUOM::Unit.new(2, :meter, :euro) }

        it { should be(object) }
      end

      context 'when units are not the same' do
        let(:other) { AUOM::Unit.new(2, :meter) }

        it_should_behave_like 'an incompatible operation'
      end
    end

    describe '#denominators' do
      subject { object.denominators }

      let(:object) { described_class.new(1, *unit) }
      let(:unit)   { [[:meter], [:euro]] }

      it 'should return denominators' do
        should eql([:euro])
      end

      it { should be_frozen }

      it_should_behave_like 'an idempotent method'
    end

    describe '#numerators' do
      subject { object.numerators }

      let(:object) { described_class.new(1, *unit) }
      let(:unit)   { [[:meter], [:euro]] }

      it 'should return numerators' do
        should eql([:meter])
      end

      it { should be_frozen }

      it_should_behave_like 'an idempotent method'
    end

    describe '#same_unit?' do
      subject { object.same_unit?(other) }

      let(:object) { described_class.new(1, *unit) }
      let(:unit)   { [[:meter], [:euro]] }

      context 'when units are the same' do
        let(:other) { AUOM::Unit.new(2, :meter, :euro) }

        it { should be(true) }
      end

      context 'when units are not the same' do
        let(:other) { AUOM::Unit.new(2, :meter) }

        it { should be(false) }
      end
    end

    describe '#denominators' do
      subject { object.scalar }

      let(:object) { described_class.new(scalar) }
      let(:scalar) { Rational(1, 2) }

      it 'should return scalar' do
        should eql(scalar)
      end

      it { should be_frozen }

      it_should_behave_like 'an idempotent method'
    end

    describe '#unitless?' do
      subject { object.unitless? }

      let(:object) { described_class.new(1, *unit) }

      context 'when unit is unitless' do
        let(:unit) { [] }
        it { should be(true) }
      end

      context 'when unit has no denominator' do
        let(:unit) { [:meter] }

        it { should be(false) }
      end

      context 'when unit has no numerator' do
        let(:unit) { [[], :meter] }

        it { should be(false) }
      end
    end

    describe '#unit' do
      subject { object.unit }

      let(:object) { described_class.new(1, *unit) }
      let(:unit)   { [[:meter], [:euro]] }

      it 'should return unit of unit instance' do
        should eql(unit)
      end

      it { should be_frozen }

      it_should_behave_like 'an idempotent method'
    end

    describe '.convert' do
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

    describe '.lookup' do
      subject { object.__send__(:lookup, value) }

      let(:object) { described_class }

      context 'with existing symbol' do
        let(:value) { :meter }

        it { should eql([1, :meter]) }
      end

      context 'with inexistent symbol' do
        let(:value) { :foo }

        it 'should raise error' do
          expect { subject }.to raise_error(ArgumentError, 'Unknown unit :foo')
        end
      end
    end

    describe '.new' do
      let(:object) { described_class }

      subject do
        described_class.new(*arguments)
      end

      shared_examples_for 'invalid unit' do
        it 'should raise ArgumentError' do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      let(:expected_scalar) { 1 }
      let(:expected_numerators) { [] }
      let(:expected_denominators) { [] }

      shared_examples_for 'valid unit' do
        it { should be_frozen }

        its(:scalar)       { should == expected_scalar       }
        its(:scalar)       { should be_frozen                }
        its(:numerators)   { should == expected_numerators   }
        its(:numerators)   { should be_frozen                }
        its(:denominators) { should == expected_denominators }
        its(:denominators) { should be_frozen                }
      end

      describe 'without arguments' do
        let(:arguments) { [] }
        it_should_behave_like 'invalid unit'
      end

      describe 'with one scalar argument' do
        let(:arguments) { [argument] }

        context 'when scalar is a string' do
          let(:argument) { '10.31' }
          it 'should raise error' do
            expect { subject }.to raise_error(ArgumentError, '"10.31" cannot be converted to rational')
          end
        end

        context 'when argument is an Integer' do
          let(:argument) { 1 }

          it_should_behave_like 'unitless unit'
          it_should_behave_like 'valid unit'
        end

        context 'when argument is a Rational' do
          let(:argument) { Rational(1, 1) }

          it_should_behave_like 'unitless unit'
          it_should_behave_like 'valid unit'
        end

        context 'when argument is something else' do
          let(:argument) { 1.0 }

          it_should_behave_like 'invalid unit'
        end
      end

      describe 'with scalar and numerator argument' do
        let(:arguments) { [1, argument] }

        context 'when argument is a valid unit' do
          let(:argument) { :kilogramm }
          let(:expected_numerators) { [:kilogramm] }

          it_should_behave_like 'valid unit'
        end

        context 'when argument is a valid unit alias' do
          let(:argument) { :kilometer }
          let(:expected_numerators) { [:meter] }
          let(:expected_scalar) { 1000 }

          it_should_behave_like 'valid unit'
        end

        context 'when argument is an array of valid units' do
          let(:argument)            { %i[kilogramm meter] }
          let(:expected_numerators) { %i[kilogramm meter] }

          it_should_behave_like 'valid unit'
        end

        context 'when argument is an array with invalid unit' do
          let(:argument) { %i[kilogramm nonsense] }

          it_should_behave_like 'invalid unit'
        end

        context 'when argument is an invalid unit' do
          let(:argument) { :nonsense }

          it_should_behave_like 'invalid unit'
        end
      end

      describe 'with scalar, numerator and denominator argument' do
        let(:arguments)           { [1, :kilogramm, argument] }
        let(:expected_numerators) { %i[kilogramm]             }

        context 'when argument is a valid unit' do
          let(:argument) { :meter }
          let(:expected_denominators) { [:meter] }

          it_should_behave_like 'valid unit'
        end

        context 'when argument is a valid unit alias' do
          let(:argument) { :kilometer }

          let(:expected_denominators) { [:meter] }
          let(:expected_scalar) { Rational(1, 1000) }

          it_should_behave_like 'valid unit'
        end

        context 'when argument is an array of valid units' do
          let(:argument)              { %i[euro meter] }
          let(:expected_denominators) { %i[euro meter] }

          it_should_behave_like 'valid unit'
        end

        context 'when argument is an array with invalid unit' do
          let(:argument) { %i[euro nonsense] }

          it_should_behave_like 'invalid unit'
        end

        context 'when argument is an invalid unit' do
          let(:argument) { :nonsense }

          it_should_behave_like 'invalid unit'
        end
      end

      context 'when numerators and denominators overlap' do
        let(:arguments)             { [1, numerators, denominators] }
        let(:numerators)            { %i[kilogramm meter euro]      }
        let(:denominators)          { %i[meter meter]               }
        let(:expected_numerators)   { %i[euro kilogramm]            }
        let(:expected_denominators) { [:meter]                      }

        it_should_behave_like 'valid unit'
      end
    end

    describe '.try_convert' do
      subject { object.try_convert(value) }

      let(:object) { AUOM::Unit }

      context 'with unit' do
        let(:value) { AUOM::Unit.new(1) }

        it { should be(value) }
      end

      context 'with nil' do
        let(:value) { nil }

        it { should be(nil) }
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

        it { should be(nil) }
      end
    end

    describe '.units' do
      subject { object.units }

      let(:object) { described_class }

      it { should be_a(Hash) }

      it_should_behave_like 'an idempotent method'
    end
  end
end
