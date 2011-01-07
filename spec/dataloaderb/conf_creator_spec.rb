require 'rspec'
require 'dataloaderb/conf_creator'
require 'tmpdir'

describe Dataloaderb::ConfCreator do
  before :each do
    @yamls = [
      FIXTURE_PROCESSES[:full_process_one]
    ]
    # ConfCreator#new expects multiple arguments, not an array, thus we splat
    @creator = Dataloaderb::ConfCreator.new(@yamls)
  end

  describe "#build_process_definitions" do
    it "should build a process definition for each yaml file" do
      @creator.processes.count.should == 1
      @creator = Dataloaderb::ConfCreator.new([FIXTURE_PROCESSES[:full_process_one], FIXTURE_PROCESSES[:full_process_two]])
      @creator.processes.count.should == 2
    end

    it "should save processes in a hash based on the name of the process" do
      @creator = Dataloaderb::ConfCreator.new([FIXTURE_PROCESSES[:full_process_one], FIXTURE_PROCESSES[:full_process_two]])
      @creator.processes['firstUpsert'].class.should == Dataloaderb::ProcessDefinition
      @creator.processes['secondUpsert'].class.should == Dataloaderb::ProcessDefinition
    end
  end

  describe "#to_xml" do
    it "should create XML with the correct values" do
      @creator.to_xml.include?('<entry key="sfdc.endpoint" value="https://www.salesforce.com"/>').should be_true
      @creator.to_xml.include?('<bean id="firstUpsert"').should be_true
      @creator.to_xml.include?('<description>First sample upsert</description>').should be_true
    end
  end

  describe "#get_binding" do
    it "should get an object of class Binding" do
      @creator.send(:get_binding).class.should == Binding
    end
  end
end
