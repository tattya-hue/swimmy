module Swimmy
  module Command
    class Openhab < Swimmy::Command::Base
      command "openhab" do |client, data, match|
        OPENHAB_URL = ENV["OPENHAB_URL"]
        if OPENHAB_URL == nil
          client.say(channel: data.channel, text: ".env に必要な項目がありません．")
          return
        end
        keyword = match[:expression]
        result_text = ""
        error_text = "データが存在しません．入力が間違っている可能性があります．\n" +
                     "\"swimmy help openhab\" と入力して使用可能なキーワードを確認してください．"
        result_data = Swimmy::Service::Openhab.new(OPENHAB_URL, "swimmy").fetch_info
        result_data.each do |data|
          if data.value == keyword
            result_text += data.state
            result_text += "\n"
          end
        end
        if result_text == ""
          client.say(channel: data.channel, text: error_text)
        else 
          client.say(channel: data.channel, text: result_text)
        end
      end 

      help do
        OPENHAB_URL = ENV["OPENHAB_URL"]
        help = ""
        if OPENHAB_URL == nil
          help = ".env に必要な項目がありません．追加して再起動してください．"
        else
          helpinfo = Swimmy::Service::Openhab.new(OPENHAB_URL, "swimmy").fetch_info
          helpinfo.each do |openhab_data|
            help += openhab_data.value
            help += "："
            help += openhab_data.config["description"]
            help += "\n"
          end
        end

        title "openhab"
        desc "キーワードに対応したOpenHAB上の情報を表示します"
        long_desc "表示したい情報を<keyword>として以下のように入力することで，
                   対応した情報を表示します．\n" +
                  "openhab <keyword>\n" +
                  "使用可能なキーワードは以下のものです．\n" +
                  "<keyword> : <description> \n" +
                  help 
      end

    end
  end
end
