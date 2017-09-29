require 'spec_helper'

describe AUOM::Unit, '#assert_same_unit' do

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
