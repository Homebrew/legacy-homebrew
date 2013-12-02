require 'formula'

class Chromedriver < Formula
  homepage 'http://code.google.com/p/chromedriver/'
  url 'http://chromedriver.storage.googleapis.com/2.7/chromedriver_mac32.zip'
  sha1 '5791a391b41e735fca0711314607e4de98aaf2dd'
  version '2.7'

  def install
    bin.install 'chromedriver'
  end
end
