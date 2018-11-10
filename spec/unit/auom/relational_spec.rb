# frozen_string_literal: true

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
