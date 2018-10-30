# frozen_string_literal: true

describe AUOM::Unit, '.try_convert' do
  subject { object.try_convert(value) }

  let(:object) { AUOM::Unit }

  context 'with unit' do
    let(:value) { AUOM::Unit.new(1) }

    it { should be(value) }
  end

  context 'with nil' do
    let(:value) { nil }

    it { should be(nil) }
  end

  context 'with fixnum' do
    let(:value) { 1 }

    it { should eql(AUOM::Unit.new(1)) }
  end

  context 'with rational' do
    let(:value) { Rational(2, 1) }

    it { should eql(AUOM::Unit.new(2)) }
  end

  context 'with Object' do
    let(:value) { Object.new }

    it { should be(nil) }
  end
end
