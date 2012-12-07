require 'spec_helper'

describe AUOM::Unit, '#unitless?' do
  subject { object.unitless? }

  let(:object) { described_class.new(1, *unit) }

  context 'when unit is unitless' do
    let(:unit) { [] }
    it { should be(true) }
  end

  context 'when unit is NOT unitless' do
    let(:unit) { [:meter] }

    it { should be(false) }
  end
end
