module Swimmy
    module Service
      class Nomnichi
        def fetch(max_page = 10)
          require "json"
          require "net/http"
          base_url = "https://gc.cs.okayama-u.ac.jp/lab/nom/articles.json?page="
          page, articles = 1, []
  
          loop do
            return articles if page > max_page
            uri = URI.parse(base_url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE # SSL証明書を無視
            req = Net::HTTP::Get.new(uri.path + "?" + uri.query + page.to_s)
            res = http.request(req)

            return articles if res.code != "200" # no more articles
            articles += JSON.parse(res.body).map {|hash| Swimmy::Resource::NomnichiArticle.parse_hash(hash)}
            return articles if Time.now - articles.last.published_on > (365*24*60*60) # limit to 1-year
            page += 1
          end
        end
      end # Nomnichi
    end # Service
  end # module Swimmy
