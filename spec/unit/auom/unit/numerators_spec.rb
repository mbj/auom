require 'spec_helper'

describe AUOM::Unit, '#numerators' do
  subject { object.numerators }

  let(:object) { described_class.new(1, *unit) }
  let(:unit)   { [[:meter], [:euro]] }

  it 'should return numerators' do
    should eql([:meter])
  end

  it { should be_frozen }

  it_should_behave_like 'an idempotent method'
end
