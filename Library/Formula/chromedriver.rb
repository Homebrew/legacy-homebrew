require 'formula'

class Chromedriver < Formula
  homepage 'http://code.google.com/p/chromedriver/'
  url 'http://chromedriver.storage.googleapis.com/2.9/chromedriver_mac32.zip'
  sha1 '16553f51a165dd202e842b99675ca6e5e1eb2a69'
  version '2.9'

  def install
    bin.install 'chromedriver'
  end
end
