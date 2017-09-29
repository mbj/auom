describe AUOM::Unit, '.new' do
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
