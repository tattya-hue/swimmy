module Swimmy
  module Resource
    class OpenhabMetadata
      attr_reader :name, :value, :state, :config
      
      def initialize(metadataname, value, state, config)
        @name = metadataname
        @value = value 
        @state = state
        @config = config
      end
    end
  end
end
