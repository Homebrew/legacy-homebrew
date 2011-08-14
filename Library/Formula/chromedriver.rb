require 'formula'

class Chromedriver < Formula
  url 'http://chromium.googlecode.com/files/chromedriver_mac_14.0.813.0.zip'
  homepage 'http://seleniumhq.wordpress.com/2011/07/07/new-chromedriver/'
  sha1 'b5f375000cb1e292cbe35966550075f9f28d50e5'

  def install
    bin.install 'chromedriver'
  end
end
