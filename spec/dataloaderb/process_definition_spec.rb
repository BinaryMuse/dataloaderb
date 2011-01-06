require 'rspec'
require 'dataloaderb/process_definition'
require 'tmpdir'

describe Dataloaderb::ProcessDefinition do
  before :each do
    @conf = Dataloaderb::ProcessDefinition.new('spec/fixtures/processes/sample_proc.yml')
  end

  context "#set/#get" do
    it "should allow setting process conf variables via the XML entry key as a string" do
      @conf.set('sfdc.endpoint', 'https://test.salesforce.com')
      @conf.get('sfdc.endpoint').should == 'https://test.salesforce.com'
    end

    it "should allow setting process conf variables via the XML entry key as a symbol" do
      @conf.set(:testsymbol, 'https://test.salesforce.com')
      @conf.get(:testsymbol).should == 'https://test.salesforce.com'
    end
  end

  context "#load_yaml" do
    it "should raise an ArgumentError if the file doesn't exist" do
      lambda {
        @conf.load_yaml('fakefile.yaml')
      }.should raise_error ArgumentError
    end

    it "should set the appropriate values via set()" do
      @conf.load_yaml('spec/fixtures/processes/sample_proc.yml')
      @conf.get('sfdc.timeoutSecs').should == '600'
      @conf.get('sfdc.debugMessages').should == 'true'
      @conf.get('process.initialLastRunDate').should == '2010-01-01T00:00:00.000-0800'
    end
  end
end
