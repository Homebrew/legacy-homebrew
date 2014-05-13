require 'formula'

class Chromedriver < Formula
  homepage 'http://code.google.com/p/chromedriver/'
  url 'http://chromedriver.storage.googleapis.com/2.10/chromedriver_mac32.zip'
  sha256 'fc412529600693430a17434652e1b765b2bd61f20a829b626d752a7b7d237c56'
  version '2.10'

  def install
    bin.install 'chromedriver'
  end
end
