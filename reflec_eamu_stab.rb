Encoding.default_external  = 'UTF-8'
# ↑デフォルトではWindows-31Jになるので、これを指定する必要がある
require 'certified'
require 'open-uri'
require 'nokogiri'
require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome

driver.navigate.to "http://p.eagate.573.jp/game/reflec/volzza/p/music/index.html"
sleep 1

## ログインのボタンを押す。まぁ直接URLを指定しても良いんだけど、練習用で。
driver.find_element(:id, "login_str").click
# rubyの仕様はhttp://www.seleniumhq.org/docs/03_webdriver.jspにある
# 巷のブログとかだと別の言語で書かれてる可能性があるので注意

konami_id = driver.find_element(:id, "KID")
konami_id.send_keys "USER"
password = driver.find_element(:id, "pass")
password.send_keys "password"

sleep 10
# この間に画像認証を人手で実行する。

# driver.find_element(:class, "login_btn textindent").click →エラーになる
password.submit

sleep 10

