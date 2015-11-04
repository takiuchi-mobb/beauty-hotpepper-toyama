#coding:utf-8

require 'open-uri' # URLにアクセスするためのライブラリの読み込み
require 'nokogiri' # Nokogiriライブラリの読み込み

# （例）MacのChromeブラウザの場合
# USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36"
USER_AGENT = "Ruby 2.2"

# HTTPヘッダーの設定例
http_header = {"User-Agent" => USER_AGENT}

# htmlの取得先
url = "http://beauty.hotpepper.jp/svcSH/macHF/salon/"

# 「次へ」のリンクアドレスを取得する(次のページへの)
xpath = {:next_link => "//*[@id=\"mainContents\"]/div[4]/div[1]/div/p[2]/a" }

charset = nil
html = open(url, http_header) do |f|
	charset = f.charset # <meta charset='文字コード'>タグの文字コードを取得(例: utf-8)
	f.read              # html形式のテキストを読み込む
end

# htmlをパース(解析)してオブジェクトを生成
doc = Nokogiri::HTML.parse(html, nil, charset)

# nokogiriのオブジェクト経由で特定の文字列を取得する
next_link = doc.xpath(xpath[:next_link])
next_text = next_link.text()
next_href = next_link.attr("href")

puts "リンクテキスト:#{next_text}, リンクパス:#{next_href}"
