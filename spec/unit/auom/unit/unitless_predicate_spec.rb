# encoding: UTF-8

require 'spec_helper'

describe AUOM::Unit, '#unitless?' do
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
