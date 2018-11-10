# frozen_string_literal: true

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
