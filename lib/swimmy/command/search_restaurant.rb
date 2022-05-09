# coding: utf-8
require "net/http"
require "json"
require "rexml/document"

module Swimmy
  module Command
    class Search_restaurant < Swimmy::Command::Base

      command "search_restaurant" do |client,data,match|
        rio = Swimmy::Service::RestaurantInfo.new
        restaurant = rio.random_fetch_info(match[:expression])
        client.say(channel: data.channel,text: restaurant.to_s)
      end #do |client,data,match|

      help do
        title "search_restaurant"
        desc "検索ワードに基づいて飲食店を検索します"
        long_desc "検索するワードを<keyword>として以下のように入力することで，検索ワードに基づいた飲食店を検索します．\n" +
                  "search_restaurant <keyword>"
      end

    end #Class Search_restaurant
  end #module Command
end #module Swimmy
