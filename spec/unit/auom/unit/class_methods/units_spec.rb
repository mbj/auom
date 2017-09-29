require 'spec_helper'

describe AUOM::Unit, '.units' do
  subject { object.units }

  let(:object) { described_class }

  it { should be_a(Hash) }

  it_should_behave_like 'an idempotent method'
end
