# coding: utf-8
module Swimmy
  module Command
    class Hizuki < Swimmy::Command::Base
      command "hizuki" do |client, data, match|
        hizuki = WorkHorse.new
        case match[:expression]
        when /\A(\d+)\/(\d+)\Z/
          message = hizuki.get_date_event($1.to_i, $2.to_i)
          client.say(channel: data.channel, text: message)
        when /\A([\+-]?\d+)\Z/
          message = hizuki.get_year_event($1.to_i)
          client.say(channel: data.channel, text: message)
        when "help"
          client.say(channel: data.channel, text: help_message("hizuki"))
        else
          client.say(channel: data.channel, text: "run \"hizuki help\"")
        end
      end

      help do
        title "hizuki"
        desc "  西暦や日付に関係する雑学を教えてくれます．"
        long_desc "hizuki MM/DD - MM月DD日に関係する雑学を教えてくれます．\n" +
                  "hizuki YYYY - 西暦YYYYに関係する雑学を教えてくれます．\n"  
      end

      ####################################################################
      ### private inner class
      class WorkHorse
        require 'date'
        require 'json'
        require 'uri'
        require 'net/http'

        def get_date_event(month=0, day=0)
          return "#{month}/#{day} は存在しない日付です" if !Date.valid_date?(4, month, day)

          uri_str = "http://numbersapi.com/#{month}/#{day}/date?json&default=There+is+no+infomation+about+the+day+#{month}/#{day}"
          fetch_and_build_message(uri_str)
        end

        def get_year_event(year=nil)
          return "#{year}年は未来の年です" if year > Date.today.year
          return "西暦0年は存在しません" if year==0

          era = if year < 0 then "#{-year} BC" else "#{year}" end
          uri_str = "http://numbersapi.com/#{year}/year?json&default=There+is+no+infomation+about+the+year+#{era}"
          fetch_and_build_message(uri_str)
        end

        def fetch_and_build_message(uri_str)
          parsed_json = fetch(uri_str)
          en_text = parsed_json["text"]
          ja_text = translate(en_text)
          return ja_text if parsed_json["found"]==false

          gen_message(en_text, ja_text)
        end

        def fetch(uri_str)
          parsed_uri = URI.parse(uri_str)
          json = Net::HTTP.get_response(parsed_uri).body
          JSON.parse(json)
        end

        def translate(en_text)
          translate_content = Swimmy::Service::Translate.new.en_to_ja(en_text)
          if translate_content["code"]==200 then translate_content["text"] else "翻訳できませんでした" end
        end

        def gen_message(en_text, ja_text)
          text = <<~EOS 
          [trivia]
          #{en_text}
          
          #{ja_text}
          EOS
        end
      end # class WorkHorse
      private_constant :WorkHorse
    end # class Plan
  end # module Command
end # module Swimmy
