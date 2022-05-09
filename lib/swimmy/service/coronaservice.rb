# coding: utf-8

require 'date'
require 'json'
require 'net/http'

module Swimmy
  module Service
    class Coronainfo

      def fetch_info(prefname)
        day = Date.today
        dayby = day - 2    #dayby => day before yesterday
        daybyby = dayby - 1
        corona_URL = "https://opendata.corona.go.jp/api/Covid19JapanAll"
        url = URI.parse(corona_URL)
        
        url.query = "date=#{dayby.strftime("%Y%m%d")}" + "&dataName=#{prefname}"
        result = JSON.parse(Net::HTTP.get(url))
        url.query = "date=#{daybyby.strftime("%Y%m%d")}" + "&dataName=#{prefname}"
        result2 = JSON.parse(Net::HTTP.get(url))
        
        info = {}

        info[:pref] = prefname
        info[:date] = dayby.strftime("%Y年%m月%d日")
        info[:date2] = daybyby.strftime("%Y年%m月%d日")
        puts result
        
        if result["itemList"][0] == nil
          info[:error] = 1
        else
          info[:error] = 0
          info[:patients] = result["itemList"][0]["npatients"]
          info[:patients2] = result2["itemList"][0]["npatients"]
        end
        
        info
      end
      
    end # class Coronainfo
  end # module Service
end # module Swimmy
