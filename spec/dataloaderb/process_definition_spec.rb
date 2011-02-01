require 'rspec'
require 'dataloaderb/process_definition'
require 'tmpdir'

describe Dataloaderb::ProcessDefinition do
  before :each do
    @conf = Dataloaderb::ProcessDefinition.new(FIXTURE_PROCESSES[:full_process_one])
  end

  it "should have basic properties" do
    @conf.should respond_to(:id)
    @conf.should respond_to(:name)
    @conf.should respond_to(:description)
    @conf.should respond_to(:entries)
  end

  describe "#set/#get" do
    it "should allow setting process conf variables via the XML entry key as a string" do
      @conf.set('sfdc.endpoint', 'https://test.salesforce.com')
      @conf.get('sfdc.endpoint').should == 'https://test.salesforce.com'
    end

    it "should allow setting process conf variables via the XML entry key as a symbol" do
      @conf.set(:testsymbol, 'https://test.salesforce.com')
      @conf.get(:testsymbol).should == 'https://test.salesforce.com'
    end
  end

  describe "#load_yaml" do
    it "should raise an ArgumentError if the file doesn't exist" do
      lambda {
        @conf.load_yaml('fakefile.yaml')
      }.should raise_error ArgumentError
    end

    it "should raise an ArgumentError if the merge file doesn't exist" do
      lambda {
        @conf.load_yaml(FIXTURE_PROCESSES[:full_process_one], "fake_merge.yml")
      }.should raise_error ArgumentError
    end

    it "should set the appropriate values via set()" do
      @conf.get('sfdc.timeoutSecs').should == '600'
      @conf.get('sfdc.debugMessages').should == 'true'
      @conf.get('process.initialLastRunDate').should == '2010-01-01T00:00:00.000-0800'
    end

    it "should expose properties via attributes" do
      @conf.id.should == 'firstUpsert'
      @conf.name.should == 'firstUpsert'
      @conf.description.should == 'First sample upsert'
    end
  end

  it "should correctly merge any partial files" do
    @conf = Dataloaderb::ProcessDefinition.new(FIXTURE_PROCESSES[:partial_process_one], FIXTURE_PROCESSES[:partial_shared])
    @conf.get('sfdc.timeoutSecs').should == '600'
    @conf.get('sfdc.debugMessages').should == 'true'
    @conf.get('process.initialLastRunDate').should == '2010-01-01T00:00:00.000-0800'
    @conf.get('process.encryptionKeyFile').should == 'C:/salesforce/dataloader/enc_pass.key'
  end
end
