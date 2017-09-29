shared_examples_for 'an operation' do
  it 'returns a new object' do
    expect(object).to_not equal(subject)
  end

  it 'is idempotent on equivalency' do
    first = subject
    fail unless RSpec.configuration.threadsafe?
    mutex = __memoized.instance_variable_get(:@mutex)
    memoized = __memoized.instance_variable_get(:@memoized)
    mutex.synchronize { memoized.delete(:subject) }
    should eql(first)
  end

  its(:scalar) { should be_kind_of(::Rational) }
end
