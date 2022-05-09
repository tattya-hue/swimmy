# coding: utf-8
module Swimmy
  module Resource
    class Restaurant

      def initialize(rexml_restaurant)
        parse(rexml_restaurant)
      end

      def parse(rexml_restaurant)
        @name = rexml_restaurant.elements["name"].text
        @address =  rexml_restaurant.elements["address"].text
        @open = rexml_restaurant.elements["open"].text
        @url = rexml_restaurant.elements["urls/pc"].text
        @credit = "Powered by <http://webservice.recruit.co.jp/|ホットペッパー Webサービス>"
      end

      def to_s #表示形式の文字列に整形
         "Name : #{@name}\n" +
         "Address : #{@address}\n" +
         "Open : #{@open}\n" +
         "URL : #{@url}\n" +
         "#{@credit}"
      end

    end
  end
end
