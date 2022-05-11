# coding: utf-8

require 'date'

module Swimmy
  module Command
    class Corona < Swimmy::Command::Base

      command "corona" do |client, data, match|
        yesterday, pref = Date.today - 1, "岡山県"
        pref = match[:expression] if match[:expression]

        info1 = Service::Coronainfo.new.fetch_info(pref, yesterday)
        info2 = Service::Coronainfo.new.fetch_info(pref, yesterday -1)

        if info1 && info2
          diff = info1.cumulative_patients - info2.cumulative_patients

          message = <<~EOS
          #{yesterday}時点での#{pref}の累計コロナ感染者数は，
          #{info1.cumulative_patients}人です．前日から#{diff}人の増加です．
          EOS
        else
          message = <<~EOS
          感染者数データベースが更新されていない，または都道府県名が正しく入力されていません．
          都道府県名は "swimmy corona 岡山県" のように入力してください．
          正しく入力されている場合にこのメッセージが表示された場合は時間をおいてから試してください．
          EOS
        end
        client.say(channel: data.channel, text: message)
      end

      help do
        title "corona"
        desc "指定した都道府県の2日前時点でのコロナ感染者数の累積を表示します"
        long_desc "corona\n" +
                  "2日前時点での岡山県のコロナ感染者数の累積を表示します\n" +
                  "さらにその前日からの増加人数を表示します\n" +
                  "corona [都道府県名]\n" +
                  "引数に指定した都道府県の2日前時点でのコロナ感染者数の累積を表示します\n" +
                  "さらにその前日からの増加人数を表示します\n"
      end
    end # class Corona
  end # module Service
end # module Swimmy
