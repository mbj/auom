shared_examples_for 'unitless unit' do
  its(:numerators)   { should == [] }
  its(:denominators) { should == [] }
  its(:unit) { should == [[],[]] }
  it { should be_unitless }
end
