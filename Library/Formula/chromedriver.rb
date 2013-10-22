require 'formula'

class Chromedriver < Formula
  homepage 'http://code.google.com/p/chromedriver/'
  url 'http://chromedriver.storage.googleapis.com/2.4/chromedriver_mac32.zip'
  sha1 'b78a808c083fe17215069c9d0ff0e6b6455d8964'
  version '2.4'

  def install
    bin.install 'chromedriver'
  end
end
