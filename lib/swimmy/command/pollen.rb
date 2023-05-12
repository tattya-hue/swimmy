# coding: utf-8

require 'date'

module Swimmy
  module Command
    class Pollen < Swimmy::Command::Base

      command "pollen" do |client, data, match|
        today  = Time.now
        address = if match[:expression] then match[:expression] else  '岡山市北区' end

        client.say(channel: data.channel, text: "花粉情報を取得しています……")

        begin
          info = Service::Pollen.new.fetch_info(address, today)
          message = <<~EOS
          #{info.date.strftime("%F")} #{(info.date.strftime("%H").to_i - 1).to_s}-#{info.date.strftime("%H")}時における#{info.address}の花粉飛散数は，
          #{info.pollen}
          EOS
        rescue Service::Pollen::CityCodeException
          message = <<~EOS
          通信に失敗したか，市区町村名が正しく入力されていません．
          市区町村名は "swimmy pollen 岡山市北区" のように入力してください．
          EOS
        rescue Service::Pollen::PollenException
          message = <<~EOS
          花粉飛散数データベースが更新されていません．
          対応する市区町村が入力されていますか？
          正しく入力されている場合にこのメッセージが表示された場合は
          WebAPIが失効している可能性があります．
          EOS
        end
        client.say(channel: data.channel, text: message)
      end

      help do
        title "pollen"
        desc "指定した市区町村の1時間前の花粉飛散数[個/m^2]を表示します．"
        long_desc "pollen \n" +
                  "岡山市北区の1時間前の花粉飛散数[個/m^2]を表示します．\n" +
                  "pollen <市区町村名>\n" +
                  "引数に指定した市区町村の1時間前の花粉飛散数[個/m^2]を表示します．\n"
      end
    end # class Pollen
  end # module Command
end # module Swimmy
