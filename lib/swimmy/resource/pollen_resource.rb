# coding: utf-8
module Swimmy
  module Resource
    class Pollen
      attr_reader :address, :date, :pollen

      def initialize(address, date, pollen)
        @address, @date = address, date
        if pollen == '-9999'
          @pollen = '観測できませんでした．'
        else
          @pollen = <<~EOS
            #{pollen.to_s} [個/m^2]です．
          EOS
        end
      end

      def to_s
        "Prefecture: #{city_code}\n" +
          "Date: #{date}\n" +
          "Pollen: #{pollen}\n"
      end
    end # class Pollen
  end # module Resource
end # module Swimmy
