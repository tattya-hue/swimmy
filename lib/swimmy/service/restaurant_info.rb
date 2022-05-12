# coding: utf-8
require "rexml/document"
require "net/http"
require "timeout"

module Swimmy
  module Service
    class RestaurantInfo

      def fetch_info(keyword)
        keyword ||="居酒屋"

        encoded_URI = URI.encode "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=5a9f7a611fa1993e&keyword=#{keyword.encode("UTF-8")}"

        url = URI.parse(encoded_URI)
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        req = Net::HTTP::Get.new(url.path + "?" + url.query)
        res = https.request(req)
        doc = REXML::Document.new(res.body)

        restaurants = []
        doc.get_elements("//results/shop").each do |shop|
          restaurants << Swimmy::Resource::Restaurant.parse_rexml(shop)
        end
        restaurants
      end

      def random_fetch_info(keyword)
        restaurants = fetch_info(keyword)
        restaurants.sample
      end

      private :fetch_info

    end
  end
end
