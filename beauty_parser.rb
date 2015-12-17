class BeautyParser
	def initialize()
		@xpath  = {
			:next_link => "//*[@id=\"mainContents\"]/div[4]/div[1]/div/p[2]/a",
			:title     => "//*[@id=\"mainContents\"]/ul/li" 
		}
	end

def parse(html, charset)

		# htmlをパース(解析)してオブジェクトを生成
		doc = Nokogiri::HTML.parse(html, nil, charset)

		# nokogiriのオブジェクト経由で特定の文字列を取得する
		begin
			next_link = doc.xpath(@xpath[:next_link])
			next_text = next_link.text()
			next_href = next_link.attribute("href")
			@xpath[:next_link] = "//*[@id=\"mainContents\"]/div[4]/div[1]/div/p[2]/a[2]"

		rescue Exception => e
			@url = nil
		end

		#各ページの最初のタイトルを表示させる
		title = doc.xpath(@xpath[:title])
		title.xpath("div/div/div[1]/h3/a").each do |h3_link|
			puts h3_link.text()
			puts h3_link.attribute("href")
			puts ""
		end

		self
	end
end