# coding: utf-8
module Swimmy
  module Command
    class Hizuki < Swimmy::Command::Base

      command "hizuki" do |client, data, match|
        hizuki = WorkHorse.new()
        case match[:expression]
        when /\A(\d+)\/(\d+)\Z/
          message = hizuki.date($1.to_i, $2.to_i)
          client.say(channel: data.channel, text: message)
        when /\A(\d+)\Z/
          message = hizuki.year($1.to_i)
          client.say(channel: data.channel, text: message)
        when "help"
          client.say(channel: data.channel, text: help_message("numi"))
        else
          client.say(channel: data.channel, text: "run \"numi help\"")
        end
      end

      help do
        title "numi"
        desc "  西暦や日付に関係する雑学を教えてくれます．"
        long_desc "numi MM/DD - MM月DD日に関係する雑学を教えてくれます．\n" +
                  "numi YYYY - 西暦YYYYに関係する雑学を教えてくれます．\n"  
      end

      ####################################################################
      ### private inner class
      class WorkHorse
        require 'json'
        require 'uri'
        require 'net/http'


        def initialize()
          @uri = "http://numbersapi.com/"
        end

        def date(month=0, day=0)
          @uri << "#{month}/#{day}/date?json"
          fetch
          message
        end

        def year(year=nil)
          @uri << "#{year}/year?json"
          fetch
          message
        end

        def date_check(month, day)
        end

        def year_check(year)
        end

        def fetch
          begin
            parsed_uri = URI.parse(@uri)
            json = Net::HTTP.get(parsed_uri)
            @result = JSON.parse(json)
          rescue => e
            @result = nil
            raise e
          end
        end

        def message
          return "error" if @result == nil

          text = <<~EOS 
          [trivia]
          #{@result["text"]}
          EOS
        end

      end # class WorkHorse
      private_constant :WorkHorse

    end # class Plan
  end # module Command
end # module Swimmy
