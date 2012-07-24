require 'formula'

class SnowLeopardOrNewer < Requirement
  def satisfied?
    MacOS.snow_leopard?
  end

  def message
    "PhantomJS requires Mac OS X 10.6 (Snow Leopard) or newer."
  end
end

class Phantomjs < Formula
  homepage 'http://www.phantomjs.org/'
  url 'http://phantomjs.googlecode.com/files/phantomjs-1.6.1-macosx-static.zip'
  sha1 '69a616fa035a815f05e1892e3ff795ef740f568b'

  depends_on SnowLeopardOrNewer.new

  def install
    bin.install 'bin/phantomjs'
  end
end
