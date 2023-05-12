# coding: utf-8
require 'pp'
require 'date'
require 'fileutils'
require 'active_support/time'
module Swimmy
    module Resource
      class Event
        attr_reader :start,:summary,:calendar_name
        def initialize(start, summary, calendar_name)
          @start = DateTime.parse(start)
          @summary = summary
          @calendar_name = calendar_name
        end

        def day_of_week
          days_of_week = ["None","月","火","水","木","金","土","日"]
          day_of_week = @start.strftime('%u')
          day_of_week = days_of_week[day_of_week.to_i];
      end
    end
  end
end