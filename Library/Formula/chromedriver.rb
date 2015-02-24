require 'formula'

class Chromedriver < Formula
  homepage 'https://sites.google.com/a/chromium.org/chromedriver/'
  url 'http://chromedriver.storage.googleapis.com/2.13/chromedriver_mac32.zip'
  sha256 '0e9e9fd10b2f9b563d6b76bffe0e5222134f14423db21e6cf7fb9bd4c6a91b30'
  version '2.13'

  def install
    bin.install 'chromedriver'
  end
end
