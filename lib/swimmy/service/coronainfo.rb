# coding: utf-8

require 'date'
require 'json'
require 'net/http'

module Swimmy
  module Service
    class Coronainfo

      def fetch_info(prefname, date)
        begin
          url = URI.parse("https://opendata.corona.go.jp/api/Covid19JapanAll")
          url.query = "date=#{date.strftime("%Y%m%d")}&dataName=#{prefname}"
          res = Net::HTTP.get(url)
          result = JSON.parse(res)
        rescue
          return nil
        end

        # データの提供元にてリザルトコードの扱いが示されていなかったため，正しくデータを取得できているか確認する
        #return nil unless result["itemList"][0]
        return Swimmy::Resource::CoronaInfo.new(
                 prefname,
                 date,
                 result["itemList"][0]["npatients"].to_i)
      end

    end # class Coronainfo
  end # module Service
end # module Swimmy
