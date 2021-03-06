# coding:utf-8

require 'open-uri' # URLにアクセスするためのライブラリの読み込み
require 'nokogiri' # Nokogiriライブラリの読み込み

class WebScraping
	def initialize()

		# （例）MacのChromeブラウザの場合
		@user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36"
		# @user_agent = "Ruby 2.2"

		# HTTPヘッダーの設定例
		@header = {"User-Agent" => @user_agent}

		@top_url = "http://beauty.hotpepper.jp"
		@url = "#{@top_url}/svcSH/macHF/salon/"
		@xpath  = {
			:next_link => "//*[@id=\"mainContents\"]/div[4]/div[1]/div/p[2]/a",
			:title     => "//*[@id=\"mainContents\"]/ul/li" 
		}
	end

	def read()
		@charset = nil
		@html = open(@url, @header) do |f|
			@charset = f.charset # <meta charset='文字コード'>タグの文字コードを取得(例: utf-8)
			f.read              # html形式のテキストを読み込む
		end
		self
	end

	def parse()

		self.read()

		begin
			self.do_parse()
			# サーバーに負荷をかけないために、1秒毎にアクセスする
			sleep(1)
		end until @url.nil?
	end

	def do_parse()
		# htmlをパース(解析)してオブジェクトを生成
		doc = Nokogiri::HTML.parse(@html, nil, @charset)

		# nokogiriのオブジェクト経由で特定の文字列を取得する
		begin
			next_link = doc.xpath(@xpath[:next_link])
			next_text = next_link.text()
			next_href = next_link.attribute("href")
			url = (next_href.nil?) ? nil : "#{@top_url}#{next_href}"
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
