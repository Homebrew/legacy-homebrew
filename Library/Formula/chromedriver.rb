require 'formula'

class Chromedriver < Formula
  url 'http://chromium.googlecode.com/files/chromedriver_mac_17.0.963.0.zip'
  homepage 'http://code.google.com/p/selenium/wiki/ChromeDriver'
  sha1 'da40247dc3da410e8ec713b7c7bc46193c3fb231'

  def install
    bin.install 'chromedriver'
  end
end
