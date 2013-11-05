require 'formula'

class Chromedriver < Formula
  homepage 'http://code.google.com/p/chromedriver/'
  url 'http://chromedriver.storage.googleapis.com/2.6/chromedriver_mac32.zip'
  sha1 '4643652d403961dd9a9a1980eb1a06bf8b6e9bad'
  version '2.6'

  def install
    bin.install 'chromedriver'
  end
end
