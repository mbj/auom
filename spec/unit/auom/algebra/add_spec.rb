describe AUOM::Algebra, '#add' do
  subject { object.add(operand) }

  let(:object) { AUOM::Unit.new(*arguments) }

  context 'when unit is unitless' do
    let(:arguments) { [1] }

    context 'and operand is a Fixnum' do
      let(:operand) { 2 }

      it_should_behave_like 'an operation'

      it { should eql(AUOM::Unit.new(3)) }
    end

    context 'and operand is a unitless unit' do
      let(:operand) { AUOM::Unit.new(2) }

      it { should eql(AUOM::Unit.new(3)) }
    end

    context 'and operand is a unitful unit' do
      let(:operand) { AUOM::Unit.new(2, :meter) }

      it_should_behave_like 'an incompatible operation'
    end
  end

  context 'when unit is unitful' do
    let(:arguments) { [1, :meter, :euro] }

    context 'and operand is a Fixnum' do
      let(:operand) { 2 }

      it_should_behave_like 'an incompatible operation'
    end

    context 'and operand is a unitless unit' do
      let(:operand) { AUOM::Unit.new(2) }

      it_should_behave_like 'an incompatible operation'
    end

    context 'and operand is a incompatible unit' do
      let(:operand) { AUOM::Unit.new(2, :euro) }

      it_should_behave_like 'an incompatible operation'
    end

    context 'and operand is a compatible unit' do
      let(:operand) { AUOM::Unit.new(2, :meter, :euro) }

      it { should eql(AUOM::Unit.new(3, :meter, :euro)) }
    end
  end
end
