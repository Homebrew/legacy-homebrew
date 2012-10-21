require 'formula'

class Chromedriver < Formula
  homepage 'http://code.google.com/p/chromedriver/'
  url 'https://chromedriver.googlecode.com/files/chromedriver_mac_23.0.1240.0.zip'
  sha1 '20a21cca0a4f0a1e25ee88e1f0bd53acbdba4cc6'

  def install
    bin.install 'chromedriver'
  end
end
