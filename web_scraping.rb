# coding:utf-8

require 'open-uri' # URLにアクセスするためのライブラリの読み込み
require 'nokogiri' # Nokogiriライブラリの読み込み

class WebScraping
	def initialize(parser)

		# （例）MacのChromeブラウザの場合
		@user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36"
		# @user_agent = "Ruby 2.2"

		# HTTPヘッダーの設定例
		@header = {"User-Agent" => @user_agent}

		@top_url = "http://beauty.hotpepper.jp"
		@url = "#{@top_url}/svcSH/macHF/salon/"

		@parser = parser
	end


	def load()

		read()

		begin
			parse()
			# サーバーに負荷をかけないために、1秒毎にアクセスする
			sleep(1)
		end until @url.nil?
	end

private
	def read()
		@charset = nil
		@html = open(@url, @header) do |f|
			@charset = f.charset # <meta charset='文字コード'>タグの文字コードを取得(例: utf-8)
			f.read              # html形式のテキストを読み込む
		end
		self
	end

	def parse()
		@parser.parse(@html, @charset)
		self
	end

end