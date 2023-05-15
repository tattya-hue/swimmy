# coding: utf-8
#
# Keep track of members' attendance
#
module Swimmy
  module Command
    class Attendance < Swimmy::Command::Base
      command 'hi', 'bye' do |client, data, match|

        cmd = match[:command]
        now = Time.now
        user = client.web_client.users_info(user: data.user).user
        user_id = user.id
        user_name = user.profile.display_name

        # log to spreadsheet
        now_s = now.strftime("%Y-%m-%d %H:%M:%S")
        client.say(channel: data.channel,
                   text: "記録中: #{now_s} #{cmd} #{user_name}...")
        begin
          logger = Swimmy::Service::AttendanceLogger.new(spreadsheet)
          logger.log(now, cmd, user_name, "")
        rescue Exception => e
          client.say(channel: data.channel, text: "履歴を記録できませんでした.")
          raise e
        end

        client.say(channel: data.channel, text: "履歴を記録しました．")

        # attendance event (for doorplate)
        doorplate_service = Swimmy::Service::Doorplate.new(mqtt_client)
        doorplate_service.send_attendance_event(cmd, user_id, user_name)
      end

      help do
        title "attendance"
        desc "hi/bye で入退室をスプレッドシートに記録し，ドアプレートを更新します"
        long_desc "attendance (hi|bye)\n" +
                  "もしくは，メンションで hi/bye だけでも OK です．"
      end
    end # class Attendance
  end # module Command
end # module Swimmy
