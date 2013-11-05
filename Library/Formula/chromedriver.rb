require 'formula'

class Chromedriver < Formula
  homepage 'http://code.google.com/p/chromedriver/'
  url 'http://chromedriver.storage.googleapis.com/2.6/chromedriver_mac32.zip'
  sha1 '4643652D403961DD9A9A1980EB1A06BF8B6E9BAD'
  version '2.6'

  def install
    bin.install 'chromedriver'
  end
end
