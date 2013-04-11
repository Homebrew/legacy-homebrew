require 'formula'

class Chromedriver < Formula
  homepage 'http://code.google.com/p/chromedriver/'
  url 'https://chromedriver.googlecode.com/files/chromedriver_mac_26.0.1383.0.zip'
  sha1 '5aec8bccdb601a5cc0a03ba5bfe32b4ac39399a1'

  def install
    bin.install 'chromedriver'
  end
end
