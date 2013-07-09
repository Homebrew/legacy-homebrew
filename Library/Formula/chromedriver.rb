require 'formula'

class Chromedriver < Formula
  homepage 'http://code.google.com/p/chromedriver/'
  url 'https://chromedriver.googlecode.com/files/chromedriver_mac32_2.1.zip'
  sha1 'c8db9cbe1bbcc202206606225e0954c709af3fe8'

  def install
    bin.install 'chromedriver'
  end
end
