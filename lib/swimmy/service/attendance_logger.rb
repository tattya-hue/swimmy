module Swimmy
  module Service
    class AttendanceLogger
      def initialize(spreadsheet)
        @sheet = spreadsheet.sheet("attendance", Swimmy::Resource::Attendance)
      end

      def log(time, inout, user_name, comment = nil)
        attendance = Swimmy::Resource::Attendance.new(time, inout, user_name, comment)
        @sheet.append_row(attendance)
      end
    end
  end
end
