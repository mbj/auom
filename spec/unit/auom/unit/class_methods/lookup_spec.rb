describe AUOM::Unit, '.lookup' do
  subject { object.__send__(:lookup, value) }

  let(:object) { described_class }

  context 'with existing symbol' do
    let(:value) { :meter }

    it { should eql([1, :meter]) }
  end

  context 'with inexistent symbol' do
    let(:value) { :foo }

    it 'should raise error' do
      expect { subject }.to raise_error(ArgumentError, 'Unknown unit :foo')
    end
  end
end
