require 'formula'

class Chromedriver < Formula
  homepage 'http://code.google.com/p/chromedriver/'
  url 'http://chromedriver.storage.googleapis.com/2.11/chromedriver_mac32.zip'
  sha256 '5abe6c42cef691ae594fd385dad8c22ff73a8a91d54854dbb6a5ceed670ab570'
  version '2.11'

  def install
    bin.install 'chromedriver'
  end
end
