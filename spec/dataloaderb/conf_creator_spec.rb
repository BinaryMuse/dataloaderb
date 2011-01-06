require 'rspec'
require 'dataloaderb/conf_creator'
require 'tmpdir'

describe Dataloaderb::ConfCreator do
  before :each do
    @yamls = [
      'spec/fixtures/processes/sample_proc.yml'
    ]
    # ConfCreator#new expects multiple arguments, not an array, thus we splat
    @creator = Dataloaderb::ConfCreator.new(*@yamls)
  end

  context "#build_process_definitions" do
    it "should build a process definition for each yaml file" do
      @creator.processes.count.should == 1
      @creator = Dataloaderb::ConfCreator.new('spec/fixtures/processes/sample_proc.yml', 'spec/fixtures/processes/sample_proc.yml')
      @creator.processes.count.should == 2
    end
  end

  context "#to_xml" do
    it "should create XML with the correct values" do
      @creator.to_xml.include?('<entry key="sfdc.endpoint" value="https://www.salesforce.com"/>').should be_true
      @creator.to_xml.include?('<bean id="firstUpsert"').should be_true
      @creator.to_xml.include?('<description>Upsert of some data somewhere</description>').should be_true
    end
  end

  context "#get_binding" do
    it "should get an object of class Binding" do
      @creator.send(:get_binding).class.should == Binding
    end
  end
end
