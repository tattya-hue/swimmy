# coding:utf-8
#
# keep track of member's stayave
#
module Swimmy
  module Command
    class Stayave < Swimmy::Command::Base
      command 'stayave' do |client, data, match|
        if match[:expression]
          usr = match[:expression]
        else
          usr = client.web_client.users_info(user: data.user).user.profile.display_name
        end
        begin
          comments = StayAverage.new(spreadsheet).calc_stayave(usr)
        rescue Exception => e
          client.say(channel: data.channel, text: "平均滞在時間を表示できませんでした.")
          raise e
        end
        client.say(channel: data.channel, text: "ユーザ　#{usr} \n #{comments}")
      end

      help do
        title "stayave"
        desc "平均滞在時間を求めます"
        long_desc "stayave <usr_name>\n"+"<usr_name>さんの平均滞在時間を求めます．<usr_name>はSlackの表示名です．"
      end
      
      ################################################################
      ## private inner class
      class StayAverage
        def initialize(spreadsheet)
          @sheet = spreadsheet.sheet("attendance", Swimmy::Resource::Attendance)
        end
        
        #hitimeはSlackでswimmy hiをした時間の集まりで[Time,Time,Time,....]となる．
        #byetimeはSlackでswimmy byeをした時間の集まりで[Time,Time,Time,....]となる．
        def str_stayave(hitime, byetime)
          average_hitime   = Time.at(calc_hitime_average_i(hitime))
          average_byetime  = Time.at(calc_byetime_average_i(byetime))
          average_staytime = Time.at(Time.at(average_byetime - average_hitime).getutc)
          str = "平均hi時刻   | " + average_hitime.strftime("%H時%M分%S秒")     + "\n" +
                "平均bye時刻  | " + average_byetime.strftime("%H時%M分%S秒")    + "\n" +
                "平均滞在時間 | " + average_staytime.strftime("%H時間%M分%S秒") + "\n" +
                "データ数     | " + hitime.size.to_s + "個" + "\n" 
          return str
        end

        def calc_hitime_average_i(time)
          sum_time = 0
          time.each do |e|
            t = Time.local(1970,1,1,e.hour,e.min,e.sec)
            sum_time += t.to_i
          end
          return sum_time / time.length
        end

        #timeはTime型のデータの配列
        def calc_byetime_average_i(time)
          sum_time = 0
          time.each do |e|
            if (e.hour < 5) && (e.hour >= 0) # 日付を超えてbyeした時刻を考慮．5時までのbyeを24時を超えて計算するための処理．
              t = Time.local(1970,1,2,e.hour,e.min,e.sec)
            else
              t = Time.local(1970,1,1,e.hour,e.min,e.sec)
            end
            sum_time += t.to_i
          end
          return sum_time / time.length
        end

        #strは，"2022-12-07 11:12:25"を想定
        def str_to_time(str)
          year, month, day = str.slice(0..9).split("-").map(&:to_i)
          hour, min, sec = str.slice(11..18).split(":").map(&:to_i)
          time = Time.local(year, month, day, hour, min, sec)
          return time
        end

        # fetch_hibyetime_from_spreadsheetはスプレッドシートからhitimeとbyetimenの対を取り出す関数．
        # hitimeをa(a_1，a_2も含む)，byetimeをb(b_1，b_2も含む)とする正規表現で表すと
        # スプレッドシート内は，例えばabababa_1a_2babaab_1b_2のように並ぶ．
        # 'ab'となっているデータのみ抽出する．上の例だと，6回抽出可能．
        # 'ab' 'ab' 'ab' a_1 'a_2b' 'ab' a 'ab_1' b_2
        # 'ab'にならないデータは無視する．
        # byetime - hitime は24時間より大きいこと(1日以上研究室に滞在すること)が稀なので，24時間より大きい場合は無視する．
        def fetch_hibyetime_from_spreadsheet(user_name)
          hitime_byetime = []
          hitime, byetime, time = nil, nil, nil
          for row in @sheet.fetch
            if row.member_name == user_name
              time = str_to_time(row.time)
              if row.inout == "hi"
                hitime = time
              elsif row.inout == "bye" && (hitime != nil)
                byetime = time
              end
              if (hitime != nil) && (byetime != nil) && ((byetime - hitime) < 24*60*60) &&((byetime - hitime) > 0)
                hitime_byetime.append([hitime,byetime])
                hitime ,byetime = nil, nil
              elsif (hitime != nil) && (byetime != nil) && ((byetime - hitime) > 24*60*60)
                hitime, byetime = nil, nil
              end
            end
          end
          return hitime_byetime
        end

        def calc_stayave(user_name)
          hitime_byetime, hitime, byetime = [], [], []
          hitime_byetime = fetch_hibyetime_from_spreadsheet(user_name)
          hitime_byetime.each do|e|
            hitime  << e[0]
            byetime << e[1]
          end
          return str_stayave(hitime, byetime)
        end 
      end # class StayAverage
    end # class Stayave
  end # module Command
end # module Swimmy
