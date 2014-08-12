# encoding: UTF-8

require 'spec_helper'

describe AUOM::Equalization, '#==' do
  subject { object == other }

  let(:object) { AUOM::Unit.new(1, :meter) }

  context 'when is other kind of object' do

    context 'that cannot be converted' do
      let(:other) { Object.new }

      it { should be(false) }
    end

    context 'that can be converted' do
      let(:other) { 1 }

      context 'and does not have the same values' do
        it { should be(false) }
      end

      context 'and does have the same values' do
        let(:other) { 1 }
        let(:object) { AUOM::Unit.new(1) }
        it { should be(true) }
      end
    end
  end

  context 'when is same kind of object' do
    let(:other) { AUOM::Unit.new(scalar, *unit) }

    let(:scalar) { 1 }
    let(:unit) { [:meter] }

    context 'and scalar and unit are the same' do
      it { should be(true) }
    end

    context 'and scalar is different' do
      let(:scalar) { 2 }
      it { should be(false) }
    end

    context 'and unit is different' do
      let(:unit) { [:euro] }
      it { should be(false) }
    end

    context 'and scalar and unit is different' do
      let(:scalar) { 2 }
      let(:unit) { [:euro] }
      it { should be(false) }
    end
  end
end
