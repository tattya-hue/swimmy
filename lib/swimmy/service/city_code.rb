# coding: utf-8

require 'net/http'
require 'uri'

module Swimmy
  module Service
    class CityCode

      class HttpException < StandardError; end
      class NonExistentException < StandardError; end

      def address_to_city_code(address)
        pre = Thread.new {address_to_prefecture_code(address)}
        add = Thread.new {address_to_address_code(address)}
        return pre.value + add.value  # 例外を素通りさせる
      end

      private

      def address_to_prefecture_code(address)
        encoded_city = URI.encode_www_form_component(address)
        url = URI.parse("https://api.excelapi.org/post/prefcode?")
        url.query = "address=#{encoded_city}}"
        begin
          res = Net::HTTP.get(url)
          raise NonExistentException.new if res.include?("ERROR")
          return res
        rescue => e
          raise NonExistentException.new if e.is_a?(NonExistentException)
          raise HttpException.new
        end
      end

      def address_to_address_code(address)
        encoded_city = URI.encode_www_form_component(address)
        url = URI.parse("https://api.excelapi.org/post/areacode?")
        url.query = "address=#{encoded_city}}"
        begin
          res = Net::HTTP.get(url)
          raise NonExistentException.new if res.include?("ERROR")
          return res
        rescue => e
          raise NonExistentException.new if e.is_a?(NonExistentException)
          raise HttpException.new
        end
      end

    end # class CityCode
  end # module Service
end # module Swimmy
