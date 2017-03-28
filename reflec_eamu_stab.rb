Encoding.default_external  = 'UTF-8'
# ↑デフォルトではWindows-31Jになるので、これを指定する必要がある
require 'certified'
require 'open-uri'
require 'nokogiri'
require 'selenium-webdriver'

require './password.rb'

driver = Selenium::WebDriver.for :chrome
driver.manage.timeouts.implicit_wait = 10 # seconds
# http://www.seleniumhq.org/docs/04_webdriver_advanced.jsp より

driver.navigate.to "http://p.eagate.573.jp/game/reflec/volzza/p/music/index.html"
sleep 1

## ログインのボタンを押す。まぁ直接URLを指定しても良いんだけど、練習用で。
driver.find_element(:id, "login_str").click
# rubyの仕様はhttp://www.seleniumhq.org/docs/03_webdriver.jspにある
# 巷のブログとかだと別の言語で書かれてる可能性があるので注意

konami_id = driver.find_element(:id, "KID")
konami_id.send_keys KONAMI_ID
password = driver.find_element(:id, "pass")
password.send_keys PASSWORD

sleep 3
# この間に画像認証を人手で実行する。

# driver.find_element(:class, "login_btn textindent").click →エラーになる
password.submit

musics = driver.find_elements(:class, "music_jkimg")

# p musics[0].find_element(:tag_name, "a").text # -> "Artifacter" 曲名が取得できる
# p musics[0].find_element(:tag_name, "a").attribute("onclick") #-> "musicDlg.show('m_info.html?id=iaRaUMiHe3aoA1iSVTTG8DwFLVMJ%2FKI5Pihk7kODHC4%3D')"遷移先のURLが取得できる

#ページ遷移するとmusicsの参照先が変わるので、最初にURLを配列に入れる
urls = musics.map{|music| music.find_element(:tag_name, "a").attribute("onclick") }

urls.each do |url|
	if /id=([\d\w%]+)'/ =~ url then
		driver.navigate.to "http://p.eagate.573.jp/game/reflec/volzza/p/music/m_info.html?id=" + $1
		
		# 方法1：できるだけSeleniumで処理する
		puts "music name : #{driver.find_element(:class, "music_dataname").text }"
		puts "artist name : #{driver.find_element(:class, "music_artist").text }"
		
		versions = driver.find_elements(:class, "music_info_box1_cont music_data_box sp_boxpink_A")
		# 現行バージョンとOLDの2つが手に入る
		versions.each do |ver|
			difs = ver.find_elements(:class, "music_info_box2")
			#各難易度が手に入る
		
#		//*[@id="musicPage"]/div[2]
		
		puts "score is #{driver.find_element(:xpath, %!//*[@id="musicPage"]/div[2]/div[4]/div/dl/dd[3]! ).text }"
		sleep 3
	else
		raise "ERROR -- invalid URL. music title: #{title}, onclick: #{onclick_str} "
	end
	
	sleep 3
end

=begin
最終的にはCSVに吐き出したい
	いきなりCSVにprintf的なことをするか
	配列にデータを保持してそれを最後にCSVにするか
	拡張性を考えると、手元にデータを一旦落としたほうがその後の処理を新規追加しやすいので、後者で行こう
=end



