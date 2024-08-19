require "time"
module Swimmy
  module Resource
    class CoopShop
      def initialize(f_name, _state, n_name, time) 
        @f_name, @n_name, @time = f_name.chomp, n_name.chomp, time       
        if @time.include?("〜")
          @start_time, @end_time = time.split("〜")
          @start_time = Time.parse(@start_time)
          parts = @end_time.split("\n") # "※"以降に注意書きがある場合があるため時刻だけを切り出す
          if parts != 0
            @end_time = parts[0]
          end 
          @end_time = Time.parse(@end_time)
        else 
          @start_time, @end_time = nil, nil
        end

      end

      def to_s
        return  name + "\t" + time + "\n"
      end

      def open?(current_time)
        if @start_time == nil || @end_time == nil
          return false
        elsif current_time >= @start_time && current_time <= @end_time
          return true
        else
          return false
        end 
      end

      def name
        if @f_name == @n_name
          return @f_name
        end
          return @f_name +"/"+ @n_name 
      end

      def time
        if @start_time == nil || @end_time == nil
          if @time.include?("休業")
            return "休業"
          else
            return ""
          end
        else
          return @start_time.strftime("%H:%M") + "~" + @end_time.strftime("%H:%M") # 例えば 10:00~14:00 という形式に変換
        end
      end
    end #class ShopInfo
  end #module Resouce
end #module Swimmy
