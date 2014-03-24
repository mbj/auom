# encoding: UTF-8

require 'spec_helper'

describe AUOM::Unit, '#denominators' do
  subject { object.scalar }

  let(:object) { described_class.new(scalar) }
  let(:scalar) { Rational(1, 2) }

  it 'should return scalar' do
    should eql(scalar)
  end

  it { should be_frozen }

  it_should_behave_like 'an idempotent method'
end
