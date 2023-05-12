# coding: utf-8

require 'date'
require 'csv'
require 'net/http'

module Swimmy
  module Service
    class Pollen

      class CityCodeException < StandardError; end
      class PollenException < StandardError; end

      def fetch_info(address, date)
        begin
          city_code = Service::CityCode.new.address_to_city_code(address)
        rescue
          raise CityCodeException.new
        end

        begin
          url = URI.parse("https://wxtech.weathernews.com/opendata/v1/pollen?")
          url.query = "citycode=#{city_code}&start=#{date.strftime("%Y%m%d")}&end=#{date.strftime("%Y%m%d")}"
          res = Net::HTTP.get(url)
          result = CSV.parse(res, headers: true)
        rescue
          raise PollenException.new
        end

        # データの提供元にてリザルトコードの扱いが示されていなかったため，正しくデータを取得できているか確認する
        return nil unless result[0]
        return Swimmy::Resource::Pollen.new(
                 address,
                 date,
                 result[date.strftime("%H").to_i - 1]["pollen"].to_i)
      end

    end # class Pollen
  end # module Service
end # module Swimmy
