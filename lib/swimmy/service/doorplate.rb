module Swimmy
  module Service
    class Doorplate
      def initialize(mqtt_client)
        @mqtt = mqtt_client
      end

      def send_attendance_event(attendance, user_id, user_name)
        require "json"

        topic = "dt/swimmy/v1/ou/eng4/nomlab/swimmy/attend"
        payload = JSON.dump({
          attendance: attendance,
          slack_user: {
            id: user_id,
            name: user_name,
          },
        })

        @mqtt.publish(topic, payload)
      end
    end
  end
end
