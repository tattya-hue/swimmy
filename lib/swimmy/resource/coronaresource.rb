# coding: utf-8
module Swimmy
  module Resource
    class CoronaInfo
      attr_reader :prefname, :date, :cumulative_patients

      def initialize(prefname, date, cumulative_patients)
        @prefname, @date, @cumulative_patients = prefname, date, cumulative_patients
      end

      def to_s
        "Prefecture: #{prefname}\n" +
          "Date: #{date}\n" +
          "Cumulative Patients: #{cumulative_patients}\n"
      end
    end # class CoronaInfo
  end # module Resource
end # module Swimmy
