# Generate a unique ID.
module Dataloaderb
  module Support
    def self.unique_id
      Time.new.to_f.to_s.sub '.', ''
    end
  end
end
