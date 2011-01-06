require 'rspec'
require 'dataloaderb/support'

describe Dataloaderb::Support do
  before :each do
    @value = Dataloaderb::Support.unique_id
  end

  it "should generate a non-nil, non-empty value" do
    @value.should_not be_empty
    @value.should_not be_nil
  end

  it "should contain only numeric characters" do
    @value.sub(/^[\d]*$/, '').should be_empty
  end
end
