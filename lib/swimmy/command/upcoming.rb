# coding: utf-8
# This is a part of https://github.com/nomlab/swimmy
require 'pp'
require 'date'
require 'fileutils'
require 'active_support/time'
require 'sheetq'
module Swimmy
  module Command
    class Upcoming < Swimmy::Command::Base
      command "upcoming" do |client, data, match|
        if match[:expression].match(" ") then
          message = "引数の数が正しくありません．検索するキーワードを<keyword>として以下のように入力してください．\n" +
          "upcoming\n" +
          "または\n" +
          "upcoming <keyword>\n"
        else
          client.say(channel: data.channel, text: "予定を取得中...")
          message = ""
          @sheet = spreadsheet.sheet("calendar", Swimmy::Resource::Calendar)
          begin
            service =  Swimmy::Service::CalendarService.new
          rescue => e
            message = 'Google OAuthの認証に失敗しました．適切な認証情報が設定されているか確認してください．'
          end
          
          begin
            # spreadsheetからカレンダー名とカレンダーidを取得する
            calendars = @sheet.fetch
            #calendarsは(カレンダー名，カレンダーid)の組
            events = service.get_events(calendars,match[:expression])
  
            if match[:expression].nil? then
              message = "1ヶ月の予定\n"
              message = "- 1ヶ月の予定はありません．\n" if events.empty?
            else
              message = "(#{match[:expression]})に関する予定\n"
              message = "- #{match[:expression]}に関する予定はありません．\n" if events.empty?
            end
            events.each do |event|
              message << "#{event.start.strftime('%m月%d日')} (#{event.day_of_week}) #{event.start.strftime('%H:%M:%S')} #{event.summary} (#{event.calendar_name})\n"
            end
  
          rescue => e
            message << "予定の取得に失敗しました．"
          end
        end
        client.say(channel: data.channel, text: message)

      end # command upcoming

      help do
        title "upcoming"
        desc "1ヶ月先までの全ての予定，またはキーワードに関する予定を表示します．"
        long_desc "引数がない場合は1ヶ月先までの予定を全て表示します．\n" +
                  "引数がある場合は1ヶ月先までの予定のうち，日時，予定名，作成者のいずれかに引数を含む予定を表示します．\n" +
                  "検索するキーワードを<keyword>として以下のように入力してください．\n" +
                  "upcoming\n" +
                  "または\n" + 
                  "upcoming <keyword>\n"
      end # help message

    end # Upcoming class
  end
end