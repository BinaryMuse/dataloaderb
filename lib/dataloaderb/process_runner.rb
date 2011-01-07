require 'dataloaderb/conf_creator'

module Dataloaderb
  class ProcessRunner
    # Create the process runner and specify the path to
    # the Apex Data Loader executable (batch) files.
    def initialize(bin_path, opts = {}, &block)
      @bin_path  = bin_path
      @conf_path = nil
      @opts      = opts
      yield self if block_given?
    end

    # Run one or more processes. Specify the processes to run by passing
    # one or more paths to process Yaml definitions.
    def run(*yamls)
      if yamls.empty? || yamls.flatten.empty?
        raise ArgumentError, "You must pass at least one argument to Dataloaderb::ProcessRunner#run"
      end

      creator = Dataloaderb::ConfCreator.new(yamls, @opts)
      # We now have a Hash of ProcessDefinitions in creator#processes.
      # We can also access the full XML for the entire set of processes via
      # creator#to_xml.
      # We can access a specific process via creator#processes['processName'].
      begin
        create_configuration(creator.to_xml)
        creator.processes.each do |name, definition|
          execute_process(name)
        end
      ensure
        remove_configuration
      end
    end

    def execute_process(process_name)
      # @bin_path and @conf_path are full paths at this point
      `#{get_process_execute_command @bin_path, @conf_path, process_name}`
    end

    # Given the path to the Apex Data Loader bin directory, the
    # path to the folder with the process-conf.xml file, and the
    # name of a process defined in the XML to run, return the
    # command that the operating system needs to run to execute
    # the process.
    def get_process_execute_command(bin_path, conf_path, process_name)
      "#{get_process_bat_path(bin_path)} #{conf_path} #{process_name}"
    end

    # Given the path to the Apex Data Loader bin directory, return
    # the expanded path of the process.bat file to be executed.
    def get_process_bat_path(bin_path)
      File.expand_path "#{bin_path}/process.bat"
    end

    protected

      def create_configuration(xml)
        base_tmpdir = @opts[:tmp_dir] || Dir.tmpdir
        @conf_path = Dir.mktmpdir(['', Dataloaderb::Support.unique_id], base_tmpdir)
        conf_file_path = "#{File.expand_path(@conf_path)}/process-conf.xml"
        File.open(conf_file_path, "w+") do |file|
          file.write(xml)
        end
      end

      def remove_configuration
        FileUtils.remove_entry_secure(@conf_path) unless @conf_path.nil?
      end
  end
end
