require 'formula'

class Chromedriver < Formula
  homepage 'http://code.google.com/p/chromedriver/'
  url 'http://chromedriver.googlecode.com/files/chromedriver_mac_19.0.1068.0.zip'
  sha1 '4a7448555dc61f900c5144d26afbfe99749433de'

  def install
    bin.install 'chromedriver'
  end
end
