require 'formula'

class Chromedriver < Formula
  homepage 'http://code.google.com/p/chromedriver/'
  url 'https://chromedriver.googlecode.com/files/chromedriver_mac32_2.2.zip'
  sha1 '8328d845afb2e5e124f38a2d72dbfc659c0936b0'

  def install
    bin.install 'chromedriver'
  end
end
