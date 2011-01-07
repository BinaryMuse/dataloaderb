require 'rspec'
require 'dataloaderb/process_runner'

describe Dataloaderb::ProcessRunner do
  before :each do
    @runner = Dataloaderb::ProcessRunner.new('spec/fixtures/bin')
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

  describe "#create_configuration" do
    it "should create a process-conf.xml file with the configuration in a temp directory" do
      @runner.instance_variable_set(:@opts, { :tmp_dir => './tmp/' })
      @runner.send(:create_configuration, 'fake xml data')
      tmp_dir = @runner.instance_variable_get(:@conf_path)
      IO.readlines("#{tmp_dir}/process-conf.xml")[0].should == "fake xml data"
      FileUtils.remove_entry_secure(tmp_dir)
    end
  end

  describe "#get_process_execute_command" do
    it "should return the correct execution command" do
      path    = @runner.send(:get_process_execute_command, "sf/bin", "myconf", "someUpserts")
      ex_path = @runner.send(:get_process_bat_path, "sf/bin")
      path.should == "#{ex_path} myconf someUpserts"
    end
  end

  describe "#run" do
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
      result = @runner.execute_process 'spec/fixutres/processes/sample_proc.yml'
      result.strip.should == "result of process"
    end
  end

  describe "with a passed block" do
    it "should execute the block in the scope of the instance" do
      Dataloaderb::ProcessRunner.new('spec/fixtures/bin') do |runner|
        runner.stub!(:get_process_execute_command).and_return("./spec/fixtures/bin/test.sh")
        result = runner.execute_process 'spec/fixutres/processes/sample_proc.yml'
        result.strip.should == "result of process"
      end
    end
  end
end
