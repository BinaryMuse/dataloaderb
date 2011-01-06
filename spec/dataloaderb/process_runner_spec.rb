require 'rspec'
require 'dataloaderb/process_runner'

describe Dataloaderb::ProcessRunner do
  before :each do
    @runner   = Dataloaderb::ProcessRunner.new('spec/fixtures/bin')
  end

  describe "#get_process_bat_path" do
    it "should return the right process.bat path given a relative path" do
      path = @runner.send(:get_process_bat_path, 'sf/bin')
      path.should == "#{Dir.getwd}/sf/bin/process.bat"
    end

    it "should return the right process.bat path given a relative path with a trailing slash" do
      path = @runner.send(:get_process_bat_path, 'sf/bin/')
      path.should == "#{Dir.getwd}/sf/bin/process.bat"
    end

    it "should return the right process.bat path given an absolute path" do
      path = @runner.send(:get_process_bat_path, '/sf/bin')
      path.should == "/sf/bin/process.bat"
    end

    it "should return the right process.bat path given an absolute path with a trailing slash" do
      path = @runner.send(:get_process_bat_path, '/sf/bin/')
      path.should == "/sf/bin/process.bat"
    end
  end

  describe "#get_process_execute_command" do
    it "should return the correct execution command" do
      path    = @runner.send(:get_process_execute_command, "sf/bin", "myconf", "someUpserts")
      ex_path = @runner.send(:get_process_bat_path, "sf/bin")
      path.should == "#{ex_path} myconf someUpserts"
    end
  end

  context "#run" do
    it "should raise an exception if no arguments are passed" do
      lambda {
        @runner.run
      }.should raise_error ArgumentError
    end

    it "should raise an exception if an empty array is passed" do
      lambda {
        @runner.run([])
      }.should raise_error ArgumentError
    end
  end

  describe "#execute_process" do
    it "should return the result of the executable" do
      @runner.stub!(:get_process_execute_command).and_return("./spec/fixtures/bin/test.sh")
      result = @runner.execute_process 'fixutres/processes/sample_proc.yml'
      result.strip.should == "result of process"
    end
  end
end
