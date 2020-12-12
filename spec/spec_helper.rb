# frozen_string_literal: true

require 'auom'
require 'rspec/its'

RSpec.shared_examples_for 'a command method' do
  it 'returns self' do
    should equal(object)
  end
end

RSpec.shared_examples_for 'an idempotent method' do
  it 'is idempotent' do
    first = subject
    fail 'RSpec not configured for threadsafety' unless RSpec.configuration.threadsafe?
    mutex    = __memoized.instance_variable_get(:@mutex)
    memoized = __memoized.instance_variable_get(:@memoized)

    mutex.synchronize { memoized.delete(:subject) }
    should equal(first)
  end
end

RSpec.shared_examples_for 'unitless unit' do
  its(:numerators)   { should == [] }
  its(:denominators) { should == [] }
  its(:unit) { should == [[], []] }
  it { should be_unitless }
end

RSpec.shared_examples_for 'an incompatible operation' do
  it 'should raise ArgumentError' do
    expect { subject }.to raise_error(ArgumentError, 'Incompatible units')
  end
end

RSpec.shared_examples_for 'an operation' do
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
