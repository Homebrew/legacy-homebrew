require 'formula'

class Chromedriver < Formula
  homepage 'http://code.google.com/p/chromedriver/'
  url 'http://chromedriver.storage.googleapis.com/2.8/chromedriver_mac32.zip'
  sha1 'b44d4666d00531f9edc5f1e89534a789fb4ec162'
  version '2.8'

  def install
    bin.install 'chromedriver'
  end
end
