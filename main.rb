#coding:utf-8

require 'open-uri' # URLにアクセスするためのライブラリの読み込み
require 'nokogiri' # Nokogiriライブラリの読み込み

# （例）MacのChromeブラウザの場合
# USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36"
USER_AGENT = "Ruby 2.2"

# HTTPヘッダーの設定例
http_header = {"User-Agent" => USER_AGENT}

# htmlの取得先
TOP_URL = "http://beauty.hotpepper.jp"
url = "#{TOP_URL}/svcSH/macHF/salon/"

# XPathの定義
xpath = {
	:next_link => "//*[@id=\"mainContents\"]/div[4]/div[1]/div/p[2]/a",
	:title     => "//*[@id=\"mainContents\"]/ul/li[1]/div[1]/div/div[1]/h3/a" 
}

begin
	charset = nil
	html = open(url, http_header) do |f|
		charset = f.charset # <meta charset='文字コード'>タグの文字コードを取得(例: utf-8)
		f.read              # html形式のテキストを読み込む
	end

	# htmlをパース(解析)してオブジェクトを生成
	doc = Nokogiri::HTML.parse(html, nil, charset)

	# nokogiriのオブジェクト経由で特定の文字列を取得する
	begin
		next_link = doc.xpath(xpath[:next_link])
		next_text = next_link.text()
		next_href = next_link.attribute("href")
		url = (next_href.nil?) ? nil : "#{TOP_URL}#{next_href}"
		xpath[:next_link] = "//*[@id=\"mainContents\"]/div[4]/div[1]/div/p[2]/a[2]"

	rescue Exception => e
		url = nil
	end

	#各ページの最初のタイトルを表示させる
	puts doc.xpath(xpath[:title]).text()

	# サーバーに負荷をかけないために、1秒毎にアクセスする
	sleep(1)
end until url.nil?
