module Swimmy
  module Command
    class Hbday < Swimmy::Command::Base
      require "sheetq"
      
      command "hbday" do |client, data, match|
        # swimmy hbday processing

        # fetch active members information from nompedia
        active_members = spreadsheet.sheet("members", Swimmy::Resource::Member).fetch.select {|m| m.active? }

        today = Date.today
        active_members.each do |m|
          # judge if birthday or not
          if m.birthday?(today)
            # if birthday, print birthday message
            message = "今日は#{m.name}さんの誕生日です！\n" + "おめでとうございます！"
            client.say(channel: data.channel, text: message)
          end
        end
      end

      help do
        title "hbday"
        desc "その日誕生日の人をお祝いします"
        long_desc "名簿からその日誕生日の人を取得して表示します(在籍メンバーのみ)"
      end

    end
  end
end
