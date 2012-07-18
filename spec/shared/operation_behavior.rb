shared_examples_for 'an operation' do
  it 'returns a new object' do
    object.should_not equal(subject)
  end

  it 'is idempotent on equivalency' do
    should eql(instance_eval(&self.class.subject))
  end
 
  its(:scalar) { should be_kind_of(::Rational) }
end

