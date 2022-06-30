# coding:utf-8
# save w
#
module Swimmy
  module Command
    class W < Swimmy::Command::Base
      command "w" do |client, data, match|

        now = Time.now

        displayed_data=""

        if match[:expression] == nil
          begin
            attendance_list = Attendance.new(spreadsheet).current_attendance
            if attendance_list == nil
              displayed_data = displayed_data + "在室者はいません。\n"
            else
              displayed_data = displayed_data + "#{now.strftime('%Y-%m-%d %H:%M:%S')}　時点での在室者を表示します。\n"
              displayed_data = displayed_data + "#{attendance_list}"
            end
          rescue Exception => e
            client.say(channel: data.channel, text:"在室者を表示できませんでした.\n")
            raise e
          end

          absence_list = Attendance.new(spreadsheet).current_absence
          if absence_list == nil
            displayed_data = displayed_data + "退室者はいません。\n"
          else
            displayed_data = displayed_data + "以下，退室者を表示します。\n"
            displayed_data = displayed_data + "#{absence_list}"
          end
        else
          displayed_data = displayed_data + "コマンドが正しくありません"
        end
        client.say(channel: data.channel, text:"#{displayed_data}")
      end

      help do
        title "w"
        desc "現在の在室者，退室者を表示します"
        long_desc "w:現在の在室者と退室者の名前を全員表示します.\n"
      end

      #######################################################
      ###private inner class
      class Attendance
        def initialize(spreadsheet)
          @sheet = spreadsheet.sheet("attendance",Swimmy::Resource::Attendance)
        end

        def current_attendance
          attendance_list = attendance()[0]
          return attendance_list.join
        end #def current_attendance

        def current_absence
          absence_list = attendance()[1]
          return absence_list.join
        end #def current_absent
       
        def attendance
          written_list = []
          absence_list = []
          attendance_list = []
          return_list = []
          sheet_list = @sheet.fetch
          count = 0
        
          for row in sheet_list.reverse
            unless written_list.include?(row.member_name)
              written_list.append("#{row.member_name}")
              case row.inout
              when "bye"
                absence_list.append("#{row.member_name}\n")
              when "hi"
                attendance_list.append("#{row.member_name}\n")
              else
              end
            else
            end
          count += 1
          if count ==100
            break
          end
          end
          return_list.push attendance_list
          return_list.push absence_list
          return return_list
        end 

      end #def Attendance
      private_constant :Attendance

    end #class W
  end #module command
end #Swimmy
