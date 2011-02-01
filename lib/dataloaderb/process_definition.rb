module Dataloaderb
  class ProcessDefinition

    attr_reader :id
    alias :name :id
    attr_reader :description
    attr_reader :entries

    # Create a new instance of a ConfCreator
    def initialize(yaml, merge = nil)
      @id          = ''
      @description = ''
      @entries     = {}
      load_yaml(yaml, merge)
    end

    def set(key, value)
      @entries[key] = value
    end

    def get(key)
      @entries[key]
    end

    # Load a process definition from a Yaml file
    def load_yaml(yaml_file, merge = nil)
      raise ArgumentError, "Cannot find file #{yaml_file}" unless File.exist?(yaml_file)
      raise ArgumentError, "Cannot find file #{merge}" unless merge.nil? || File.exist?(merge)
      unless merge.nil?
        merge_data = YAML.load_file(merge)
        merge_data.each do |key, value|
          self.set(key, value)
        end
      end
      proc         = YAML.load_file(yaml_file)
      @id          = proc['id']
      @description = proc['description']
      proc['properties'].each do |key, value|
        self.set(key, value)
      end
    end
  end
end
