# coding: utf-8
module Swimmy
  module Command
    class Numinfo < Swimmy::Command::Base

      command "numi" do |client, data, match|
        case match[:expression]
        when /\A([\+-]?\d+)[\s\t]*([mt]?)\Z/
          type = if $2=="m" then "math" elsif $2=="t" then "trivia" else "" end
          uri = "http://numbersapi.com/#{$1.to_i}/#{type}?json"
          ni = WorkHorse.new(uri)
          ni.fetch
          client.say(channel: data.channel, text: ni.message)
        when nil
          uri = "http://numbersapi.com/random/trivia?json"
          ni = WorkHorse.new(uri)
          ni.fetch
          client.say(channel: data.channel, text: ni.message)
        when "help"
          client.say(channel: data.channel, text: help_message("numi"))
        else
          client.say(channel: data.channel, text: "run \"numi help\"")
        end
      end

      help do
        title "numi"
        desc "  数が関係する雑学を教えてくれます．"
        long_desc "numi - ランダムな数について，その数に関する雑学を教えてくれます．\n" +
                  "numi NUM - 指定した数であるNUMに関係する雑学を教えてくれます．\n"  
      end

      ####################################################################
      ### private inner class
      class WorkHorse
        require 'json'
        require 'uri'
        require 'net/http'


        def initialize(uri)
          @uri = uri
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
          [number]
          #{@result["number"]}

          [trivia]
          #{@result["text"]}
          EOS
        end

      end # class WorkHorse
      private_constant :WorkHorse

    end # class Plan
  end # module Command
end # module Swimmy
