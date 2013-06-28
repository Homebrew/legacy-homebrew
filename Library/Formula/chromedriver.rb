require 'formula'

class Chromedriver < Formula
  homepage 'http://code.google.com/p/chromedriver/'
  url 'https://chromedriver.googlecode.com/files/chromedriver_mac32_2.0.zip'
  sha1 '9b4a090f65ac3e62c9b4d5c63a263a68e68919d9'

  def install
    bin.install 'chromedriver'
  end
end
