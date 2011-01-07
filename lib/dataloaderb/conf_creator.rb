require 'dataloaderb/process_definition'
require 'dataloaderb/support'
require 'erb'
require 'fileutils'
require 'tmpdir'
require 'yaml'

module Dataloaderb
  class ConfCreator
    attr_reader :processes

    # Create a new instance of a ConfCreator
    def initialize(yamls, opts = {})
      @processes = {}
      @opts      = opts
      build_process_definitions(yamls)
    end

    def build_process_definitions(yamls)
      yamls.each do |yaml|
        if @opts[:merge].nil? || @opts[:merge].empty?
          proc_def = Dataloaderb::ProcessDefinition.new(yaml)
        else
          proc_def = Dataloaderb::ProcessDefinition.new(yaml, @opts[:merge])
        end
        process_name = proc_def.id
        @processes[process_name] = proc_def
      end
    end

    # Return the text for an Apex Data Loader process-conf.xml file
    def to_xml
      # TODO: Don't unindent <%%
      erb = ERB.new File.new(File.expand_path('templates/process-conf.xml.erb',File.dirname(__FILE__))).readlines.join.gsub(/^\s+<%/, "<%"), nil, '<>'
      erb.result(get_binding)
    end

    private

      def get_binding
        binding
      end
  end
end
