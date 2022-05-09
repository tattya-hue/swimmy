# coding: utf-8
module Swimmy
  module Service
    class RestaurantInfo

      def initialize()
      end

      def fetch_info(search_word)
        if search_word == nil then
          keyword = "日本"
        else
          keyword = search_word
        end
        
        encoded_URI = URI.encode "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=5a9f7a611fa1993e&keyword=#{keyword.encode("UTF-8")}"

        url = URI.parse(encoded_URI)
        https = Net::HTTP.new(url.host, url.port)  
        https.use_ssl = true
        req = Net::HTTP::Get.new(url.path + "?" + url.query)
        res = https.request(req)
        doc = REXML::Document.new(res.body)
      end

      def random_fetch_info(search_word)
        doc = fetch_info(search_word)
        # 1~(SHOPの上限数)の間で無作為に数を選ぶ
        upper_limit = doc.get_elements("//results/shop").size
        random_num = rand(1..upper_limit)
        random_restaurant = doc.elements["results/shop[#{random_num}]"]
        Swimmy::Resource::Restaurant.new(random_restaurant)
      end

    end
  end
end
