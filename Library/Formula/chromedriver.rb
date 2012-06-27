require 'formula'

class Chromedriver < Formula
  homepage 'http://code.google.com/p/chromedriver/'
  url 'http://chromedriver.googlecode.com/files/chromedriver_mac_21.0.1180.4.zip'
  sha1 'ea6f2f45c835d3413fde3a7b08e5e3e4db6dc3f9'

  def install
    bin.install 'chromedriver'
  end
end
