require 'formula'

class ChromeDriver < Formula
  url 'http://selenium.googlecode.com/files/chromedriver_mac_13.0.775.0.zip'
  homepage 'http://seleniumhq.org/'
  md5 '797971a75189c75cbfa4f8128196a1a8'

  def install
    bin.install 'chromedriver'
  end
end
