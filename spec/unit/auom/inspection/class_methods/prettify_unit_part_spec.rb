require 'spec_helper'

describe AUOM::Inspection,'.prettify_unit_part' do
  subject { object.prettify_unit_part(part) }

  let(:object) { AUOM::Inspection }

  context 'with simple part' do
    let(:part) { [:meter] }
    it { should eql('meter') }
  end

  context 'with mixed part' do
    let(:part) { [:meter,:euro] }
    it { should eql('euro*meter') }
  end

  context 'with complex part' do
    let(:part) { [:meter,:meter,:euro] }
    it { should eql('meter^2*euro') }
  end

  context 'with very complex part' do
    let(:part) { [:meter,:meter,:euro,:euro,:kilogramm] }
    it { should eql('euro^2*meter^2*kilogramm') }
  end
end
