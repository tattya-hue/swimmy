module Swimmy
    module Command
        class News < Swimmy::Command::Base
            #api仕様:https://newsapi.org

            command "news" do |client, data, match|
                getnews = Service::Newsapi.new(ENV['NEWS_API_KEY']).news_api[0]
                message = "#{getnews.author}\n"+"#{getnews.title}\n"+"#{getnews.url}"
                client.say(channel: data.channel, text: message)
            end

            help do
                title "news"
                desc "本日話題になったニュースを表示する"
                long_desc "最新のニュースをNews APIから取得して表示する"
            end
        end
    end
end
