require 'spec_helper' 
describe SUnits::Unit,'.new' do
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
    it 'should have the correct scalar' do
      subject.scalar.should == expected_scalar
    end

    it 'should have the expected numerators' do
      subject.numerators.should == expected_numerators
    end

    it 'should have the expected denominators' do
      subject.denominators.should == expected_denominators
    end
  end


  describe 'without arguments' do
    let(:arguments) { [] }
    it_should_behave_like 'invalid unit'
  end

  describe 'with one hash argument' do
    let(:arguments) { [hash] }

    context 'when only scalar is given' do
      context 'and scalar is given as array' do
        let(:hash) { {:scalar => [1,1] } }
       
        it_should_behave_like 'unitless unit'
        it_should_behave_like 'valid unit'
      end

      context 'and scalar is given as fixnum' do
        let(:hash) { {:scalar => 1 } }
       
        it_should_behave_like 'unitless unit'
        it_should_behave_like 'valid unit'
      end

      context 'and scalar is given as float' do
        let(:hash) { {:scalar => 1.0 } }
       
        it_should_behave_like 'invalid unit'
      end
    end

    context 'when scalar and numerators are given' do 
      let(:hash) { { :scalar => 1, :numerators => [:meter] } }

      let(:expected_numerators) { [:meter] }

      it_should_behave_like 'valid unit'
    end

    context 'when scalar and numerators are given as string' do 
      let(:hash) { { :scalar => 1, :numerators => ['meter'] } }

      let(:expected_numerators) { [:meter] }

      it_should_behave_like 'valid unit'
    end

    context 'when scalar and numerators are given as string alias' do 
      let(:hash) { { :scalar => 1, :numerators => ['kilometer'] } }

      let(:expected_numerators) { [:meter] }
      let(:expected_scalar)     { 1000 }

      it_should_behave_like 'valid unit'
    end

    context 'when scalar and denominators are given' do
      let(:hash) { { :scalar => 1, :denominators => [:meter] } }

      let(:expected_denominators) { [:meter] }

      it_should_behave_like 'valid unit'
    end

    context 'when scalar and denominators are given as string' do
      let(:hash) { { :scalar => 1, :denominators => ['meter'] } }

      let(:expected_denominators) { [:meter] }

      it_should_behave_like 'valid unit'
    end

    context 'when scalar and denominators are given as string alias' do
      let(:hash) { { :scalar => 1, :denominators => ['kilometer'] } }

      let(:expected_denominators) { [:meter] }
      let(:expected_scalar)       { Rational(1,1000) }

      it_should_behave_like 'valid unit'
    end

    context 'when scalar, numerators and denominators are given' do
      let(:hash) { { :scalar => 1, :numerators => [:meter],:denominators => [:kilogramm] } }

      let(:expected_denominators) { [:kilogramm] }
      let(:expected_numerators)   { [:meter] }

      it_should_behave_like 'valid unit'
    end

    context 'when scalar, numerators and denominators are given as string keys' do
      let(:hash) { { 'scalar' => 1, 'numerators' => [:meter],'denominators' => [:kilogramm] } }

      let(:expected_denominators) { [:kilogramm] }
      let(:expected_numerators)   { [:meter] }

      it_should_behave_like 'valid unit'
    end

    context 'when scalar and value is given' do
      let(:hash) { { :scalar => 1, :value => 1 } }

      it_should_behave_like 'valid unit'
    end

    context 'when scalar and value is given as string keys' do
      let(:hash) { { 'scalar' => 1, 'value' => 1 } }

      it_should_behave_like 'valid unit'
    end
  end

  describe 'with one scalar argument' do
    let(:arguments) { [argument] }

    context 'when scalar is a string' do
      context 'and string is in a simple float format' do
        let(:argument) { '10.31' }
        let(:expected_scalar) { Rational(1031,100) }

        it_should_behave_like 'valid unit'
      end

      context 'and string is in a simple fixnum format' do
        let(:argument) { '1031' }
        let(:expected_scalar) { Rational(1031,1) }

        it_should_behave_like 'valid unit'
      end

      context 'and string is not in a registred format' do
        let(:argument) { 'something' }
        
        it_should_behave_like 'invalid unit'
      end
    end

    context 'when argument is a Fixnum' do
      let(:argument) { 1 }

      it_should_behave_like 'unitless unit'
      it_should_behave_like 'valid unit'
    end

    context 'when argument is a Rational' do
      let(:argument) { Rational(1,1) }

      it_should_behave_like 'unitless unit'
      it_should_behave_like 'valid unit'
    end

    context 'when argument is something else' do
      let(:argument) { 1.0 }

      it_should_behave_like 'invalid unit'
    end
  end

  describe 'with scalar and numerator argument' do
    let(:arguments) { [1,argument] }

    context 'when argument is nil' do
      let(:argument) { nil }

      it_should_behave_like 'valid unit'
    end

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
      let(:argument) { [:kilogramm,:meter] }
      let(:expected_numerators) { [:kilogramm,:meter] }

      it_should_behave_like 'valid unit'
    end

    context 'when argument is an array with invalid unit' do
      let(:argument) { [:kilogramm,:nonsense] }

      it_should_behave_like 'invalid unit'
    end

    context 'when argument is an invalid unit' do
      let(:argument) { :nonsense }

      it_should_behave_like 'invalid unit'
    end
  end

  describe 'with scalar, numerator and denominator argument' do
    let(:arguments) { [1,:kilogramm,argument] }
    let(:expected_numerators)   { [:kilogramm] }

    context 'when argument is nil' do
      let(:argument) { nil }

      it_should_behave_like 'valid unit'
    end


    context 'when argument is a valid unit' do 
      let(:argument) { :meter }
      let(:expected_denominators) { [:meter] }

      it_should_behave_like 'valid unit'
    end

    context 'when argument is a valid unit alias' do
      let(:argument) { :kilometer }

      let(:expected_denominators) { [:meter] }
      let(:expected_scalar) {  Rational(1,1000) }

      it_should_behave_like 'valid unit'
    end


    context 'when argument is an array of valid units' do
      let(:argument) { [:euro,:meter] }
      let(:expected_denominators) { [:euro,:meter] }

      it_should_behave_like 'valid unit'
    end

    context 'when argument is an array with invalid unit' do
      let(:argument) { [:euro,:nonsense] }

      it_should_behave_like 'invalid unit'
    end

    context 'when argument is an invalid unit' do
      let(:argument) { :nonsense }

      it_should_behave_like 'invalid unit'
    end
  end

  context 'when numerators and denominators overlap' do
    let(:arguments) { [1,numerators,denominators] }
    let(:numerators) { [:kilogramm,:meter,:euro] }
    let(:denominators) { [:meter,:meter] }
    let(:expected_numerators) { [:euro,:kilogramm] }
    let(:expected_denominators) { [:meter] }

    it_should_behave_like 'valid unit'
  end
end
