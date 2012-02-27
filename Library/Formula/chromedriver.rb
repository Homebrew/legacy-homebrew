require 'formula'

class Chromedriver < Formula
  url 'http://chromium.googlecode.com/files/chromedriver_mac_18.0.995.0.zip'
  homepage 'http://code.google.com/p/selenium/wiki/ChromeDriver'
  sha1 '5ff64a13d56ad6b95a2c9d430f357d72064a6d7d'

  def install
    bin.install 'chromedriver'
  end
end
