require 'spec_helper'

describe AUOM::Equalization,'#eql?' do
  subject { object.eql?(other) }

  let(:object) { AUOM::Unit.new(1,:meter) }

  context 'when is other kind of object' do
    let(:other) { Object.new }

    it { should be(false) }
  end

  context 'when is same kind of object' do
    let(:other) { AUOM::Unit.new(scalar,*unit) }

    let(:scalar) { 1 }
    let(:unit) { [:meter] }

    context 'and scalar and unit are the same' do
      it { should be(true) }
    end

    context 'and scalar is differend' do
      let(:scalar) { 2 }
      it { should be(false) }
    end

    context 'and unit is differend' do
      let(:unit) { [:euro] }
      it { should be(false) }
    end

    context 'and scalar and unit is differend' do
      let(:scalar) { 2 }
      let(:unit) { [:euro] }
      it { should be(false) }
    end
  end
end
