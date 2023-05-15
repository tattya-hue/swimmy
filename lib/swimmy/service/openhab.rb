module Swimmy
  module Service
    class Openhab
      require "json"
      require "uri"
      require "open-uri"

      def initialize(openhab_url, metadataname)
        @openhab_url = openhab_url + "/rest/items?metadata=" + metadataname
        @metadataname = metadataname 
      end

      def fetch_info
        retval = []
        opinfo = JSON.parse(URI.open(@openhab_url, &:read)) 
        opinfo.each do |openhab_data|
          next if openhab_data["metadata"] == nil
          retval.push(Swimmy::Resource::OpenhabMetadata.new(@metadataname, 
                                                            openhab_data["metadata"][@metadataname]["value"],
                                                            openhab_data["state"],
                                                            openhab_data["metadata"][@metadataname]["config"]))
        end
        return retval
      end

    end # class Openhabinfo
  end # module Service
end # module Swimmy
