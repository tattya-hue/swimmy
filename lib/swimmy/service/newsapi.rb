module Swimmy
    module Service
        class Newsapi
            require 'news-api'

            def initialize(news_api_key)
                @api_key = news_api_key
            end

            def news_api()
                newsapi = News.new(@api_key)
                top_headlines = newsapi.get_top_headlines(country: 'jp')
            end
        end
    end
end