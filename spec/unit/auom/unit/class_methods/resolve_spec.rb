require 'spec_helper'

describe AUOM::Unit,'.resolve' do
  subject { described_class.send(:resolve, [:euro], 1, :*) }

  its(:size) { should be(2) }
end
