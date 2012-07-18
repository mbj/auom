require 'spec_helper'

describe AUOM::Equalization, '#hash' do
  subject { object.hash }

  let(:object) { AUOM::Unit.new(1) }

  it { should be_a(Fixnum) }

  it_should_behave_like 'an idempotent method'

  it { should be(Rational(1).hash ^ [[],[]].hash) }
end
