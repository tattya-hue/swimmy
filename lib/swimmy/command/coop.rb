require 'rexml/document'
require 'pp'
require 'time'

module Swimmy
  module Command
    class Coop < Swimmy::Command::Base
      command "coop" do |client, data, match|                 
        shops = Swimmy::Service::Coop.new.get_shopinfolist("https://vsign.jp/okadai/maruco/shops")
        script = ""
        case match[:expression]
        when "open"
          pred = ->(s){s.open?(Time.new)}
        when "time"
          pred = ->(_){true}
        end
        script = shops.select(&pred).map{|s| s.to_s}
        client.say(channel: data.channel, text: script)
      end
      
      help do
        title "coop"
        desc "生協の情報を表示する"
        long_desc "coop open - 空いているショップを表示する\n" +
                  "coop time - ショップごとの営業時間を表示する"
      end #help
    end #class Coop    
  end #module Command
end #module Swimmy 
