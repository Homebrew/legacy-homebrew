require 'formula'

class Chromedriver < Formula
  homepage 'http://code.google.com/p/chromedriver/'
  url 'https://chromedriver.googlecode.com/files/chromedriver_mac32_2.3.zip'
  sha1 '6c89e33dbafc6f8a19ff62035fad545dda212271'

  def install
    bin.install 'chromedriver'
  end
end
