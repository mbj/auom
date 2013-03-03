shared_examples_for 'an operation' do
  it 'returns a new object' do
    object.should_not equal(subject)
  end

  it 'is idempotent on equivalency' do
    first = subject
    __memoized.delete(:subject)
    should eql(first)
  end
 
  its(:scalar) { should be_kind_of(::Rational) }
end

