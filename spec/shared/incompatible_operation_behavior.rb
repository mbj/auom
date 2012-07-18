shared_examples_for 'an incompatible operation' do
  it 'should raise ArgumentError' do
    expect { subject }.to raise_error(ArgumentError,'Incompatible units for substraction or addition')
  end
end
