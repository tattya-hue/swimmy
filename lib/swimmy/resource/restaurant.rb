# coding: utf-8

module Swimmy
  module Resource
    class Restaurant

      def initialize(name, address, open, url)
        @name = name
        @address = address
        @open = open
        @url = url
      end

      def self.parse_rexml(rexml_restaurant)
        name = rexml_restaurant.elements["name"].text
        address =  rexml_restaurant.elements["address"].text
        open = rexml_restaurant.elements["open"].text
        url = rexml_restaurant.elements["urls/pc"].text
        Restaurant.new(name, address, open, url)
      end

      def to_s
         "Name : #{@name}\n" +
         "Address : #{@address}\n" +
         "Open : #{@open}\n" +
         "URL : #{@url}\n"
      end

    end
  end
end
