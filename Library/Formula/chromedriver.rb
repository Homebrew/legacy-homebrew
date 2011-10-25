require 'formula'

class Chromedriver < Formula
  url 'http://chromium.googlecode.com/files/chromedriver_mac_16.0.902.0.zip'
  homepage 'http://code.google.com/p/selenium/wiki/ChromeDriver'
  sha1 '2d0d786b0b1bf08472da61301a99cd592a3fa88b'

  def install
    bin.install 'chromedriver'
  end
end
