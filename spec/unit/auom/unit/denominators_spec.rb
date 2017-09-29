describe AUOM::Unit, '#denominators' do
  subject { object.denominators }

  let(:object) { described_class.new(1, *unit) }
  let(:unit)   { [[:meter], [:euro]] }

  it 'should return denominators' do
    should eql([:euro])
  end

  it { should be_frozen }

  it_should_behave_like 'an idempotent method'
end
