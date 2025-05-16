module Swimmy
  module Service
    class Translate
      require 'json'
      require 'uri'
      require 'net/http'
      
      def en_to_ja(en_text)
        translate_uri = "#{ENV['TRANSLATE_API_URL']}"
        translate_uri << "?text=#{en_text}&source=en&target=ja"
        translate_json = fetch_with_redirect(translate_uri)
        JSON.parse(translate_json)
      end

      private

      def fetch_with_redirect(uri_str, limit = 5)
        raise 'Too many HTTP redirects' if limit == 0
    
        parsed_uri = URI.parse(uri_str)
        response = Net::HTTP.get_response(parsed_uri)        
        case response
        when Net::HTTPSuccess
          return response.body
        when Net::HTTPRedirection
          location = response['location']
          warn "redirected to #{location}"
          fetch_with_redirect(location, limit - 1)
        else
          nil
        end
      end
    end
  end
end
