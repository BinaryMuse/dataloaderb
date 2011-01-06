module Dataloaderb
  class ProcessDefinition

    attr_reader :id
    attr_reader :description
    attr_reader :entries

    # Create a new instance of a ConfCreator
    def initialize(yaml)
      @id          = ''
      @description = ''
      @entries     = {}
      load_yaml(yaml)
    end

    def set(key, value)
      @entries[key] = value
    end

    def get(key)
      @entries[key]
    end

    # Load a process definition from a Yaml file
    def load_yaml(yaml_file)
      raise ArgumentError, "Cannot find file #{yaml_file}" unless File.exist?(yaml_file)
      proc         = YAML.load_file(yaml_file)
      @id          = proc['id']
      @description = proc['description']
      proc['properties'].each do |key, value|
        self.set(key, value)
      end
    end
  end
end
