describe AUOM::Unit, '#same_unit?' do

  subject { object.same_unit?(other) }

  let(:object) { described_class.new(1, *unit) }
  let(:unit)   { [[:meter], [:euro]] }

  context 'when units are the same' do
    let(:other) { AUOM::Unit.new(2, :meter, :euro) }

    it { should be(true) }
  end

  context 'when units are not the same' do
    let(:other) { AUOM::Unit.new(2, :meter) }

    it { should be(false) }
  end

end
