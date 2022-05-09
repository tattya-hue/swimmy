# coding: utf-8

module Swimmy
  module Command
    class Corona < Swimmy::Command::Base

      command "corona" do |client, data, match|
        client.say(channel: data.channel, text: Infodisplay.new.textmaker(match[:expression]))
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
    
    class Infodisplay

      def measurechange(patients1, patients2)
        change = patients1.to_i - patients2.to_i
        result = change.to_s
        return result
      end

        
      def textmaker(input)
        prefname = input
        if prefname == nil then
          coronainfo = Service::Coronainfo.new.fetch_info("岡山県")
        else
          coronainfo = Service::Coronainfo.new.fetch_info(prefname)
        end
        
          corona_diff = measurechange(coronainfo[:patients], coronainfo[:patients2])

          if coronainfo[:error] == 0
          message = <<~EOS
          #{coronainfo[:date]}時点での#{coronainfo[:pref]}の累計コロナ感染者数は，
          #{coronainfo[:patients]}人です．
          #{coronainfo[:date2]}より#{corona_diff}人の増加です．
          EOS

          else
          message = <<~EOS
          感染者数データベースが更新されていない，または都道府県名が正しく入力されていません．
          都道府県名は "swimmy corona 岡山県" のように入力してください．
          正しく入力されている場合にこのメッセージが表示された場合は時間をおいてから試してください．
          EOS
          end
          
        end
        
      end
    
  end # module Service
end # module Swimmy
