require 'formula'

class Chromedriver < Formula
  homepage 'http://code.google.com/p/chromedriver/'
  url 'http://chromedriver.googlecode.com/files/chromedriver_mac_20.0.1133.0.zip'
  sha1 '00013555f4383dee3308d180eb868ca27e865179'

  def install
    bin.install 'chromedriver'
  end
end
