require 'dataloaderb/conf_creator'

module Dataloaderb
  class ProcessRunner
    # Create the process runner and specify the path to
    # the Apex Data Loader executable (batch) files.
    def initialize(bin_path)
      @bin_path = bin_path
    end

    # Run one or more processes. Specify the processes to run by passing
    # one or more paths to process Yaml definitions.
    def run(*yamls)
      if yamls.empty? || yamls.flatten.empty?
        raise ArgumentError, "You must pass at least one argument to Dataloaderb::ProcessRunner#run"
      end

      creator = Dataloaderb::ConfCreator.new(yamls)
    end

    def execute_process(process_name)
      # @bin_path and @conf_path are full paths at this point
      `#{get_process_execute_command}`
    end

    protected

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
  end
end
