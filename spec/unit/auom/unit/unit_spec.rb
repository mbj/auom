# encoding: UTF-8

require 'spec_helper'

describe AUOM::Unit, '#unit' do
  subject { object.unit }

  let(:object) { described_class.new(1, *unit) }
  let(:unit)   { [[:meter], [:euro]] }

  it 'should return unit of unit instance' do
    should eql(unit)
  end

  it { should be_frozen }

  it_should_behave_like 'an idempotent method'
end
