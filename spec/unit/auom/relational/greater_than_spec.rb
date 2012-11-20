require 'spec_helper'

describe AUOM::Relational,'#greater_than?' do

  subject { object.greater_than?(operand) }

  let(:object) { AUOM::Unit.new(1, :meter) }

  let(:operand) { AUOM::Unit.new(scalar, unit) }

  context 'when operand unit is the same' do

    let(:unit) { :meter }

    context 'and operand scalar is less than receiver scalar' do
      let(:scalar) { 0 }

      it { should be(true) }
    end

    context 'and operand scalar is equal to receiver scalar' do
      let(:scalar) { 1 }

      it { should be(false) }
    end

    context 'and operand scalar is greater than receiver scalar' do
      let(:scalar) { 2 }

      it { should be(false) }
    end
  end

  context 'when operand unit is not the same' do
    let(:scalar) { 1     }
    let(:unit)   { :euro }

    it_should_behave_like 'an incompatible operation'
  end
end
