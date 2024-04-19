# スクレイピング対象のwebサイトは例えば以下のようになっている
#
# <h3 class='bg-title-gray'>
# ピーチショップ
# </h3>
# <div class='list-card-box hours-card-box'>
#   <a href='/okadai/maruco/shops/84'>
#     <div class='row list-card-item item-open'>
#       <div class='col-9 col-lg-12 px-2'>
#         <div class='name'>
#           <div class='d-block mb-2'>
#             <span class='badge-shop-open'>
#               OPEN
#             </span>
#           </div>
#           <span class='text'>
#             ピーチショップ
#           </span>
#         </div>
#         <div class='time'>
#           <div class='shop-day-times mt-2'>
#             10:00〜17:00
#           </div>
#         </div>
#       </div>
#       <div class='col-3 col-lg-12 link pl-lg-2 mt-lg-2'>
#         <p class='mb-0 link-underline-dark'>
#           明日以降
#         </p>
#       </div>
#     </div>
#
#
# 今回実装した手法では，はじめに 'bg-title-gray'というクラスを探し，店舗名を取り出す．
# 次に，'bg-title-gray' の隣のノードを探索し，'row list-card-item item-open' というクラスが含まれるノードを取り出す．
# 取り出したノードを探索し，'text' クラスからサブ店舗名 (例えばピーチショップのトラベルサービス)，
# 'time' クラスから営業時間，'badge-shop' クラスから開閉状況を取り出す．

require 'open-uri'
require 'nokogiri'

module Swimmy
  module Service
    class Coop
      def get_shopinfo(f_name, state, n_name, time)
        shop = []
        n_name.zip(state, time).each do |n_name, state, time|
          shop  << Swimmy::Resource::CoopShop.new(f_name, state, n_name, time)
        end
        return shop
      end
      def search(element, path)
        array=[]
        element.search(path).each do |node|
          text = node.text
          text = text.gsub(/\s+/,"\n") # 余分な改行やスペースを削除
          text = text.gsub(/\n{2,}/,"\n")
          text.slice!(0)
          array << text
        end
        return array
      end
      def get_shopinfolist(url)
        shops = []
        html = Nokogiri::HTML.parse(URI.open(url))
        # 'bg-title-gray'というクラスを探し，店舗名を取り出す．
        html.xpath('//h3[@class="bg-title-gray"]').each do |str| 
          n_name, state, time = [], [], []
          f_name = str.text.strip
          # 'row list-card-item item-open' というクラスが含まれるノードを取り出す．
          node = str.next_element.search('.//div[contains(@class, "row list-card-item")]')    
          # 取り出したノードを探索し，'text' クラスからサブ店舗名 (例えばピーチショップのトラベルサービス)，
          # 'time' クラスから営業時間，'badge-shop' クラスから開閉状況を取り出す．       
          n_name = search(node, './/span[@class = "text"]')
          state = search(node, './/span[contains(@class, "badge-shop")]')
          time = search(node, './/div[@class = "time"]')
          shops += get_shopinfo(f_name, state, n_name, time)
        end
        return shops
      end
    end
  end 
end # module Swimmy
