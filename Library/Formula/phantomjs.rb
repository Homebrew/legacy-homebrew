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
  url "http://phantomjs.googlecode.com/files/phantomjs-1.6.0-macosx-static.zip"
  sha1 '7e4a4f069ffb32ab693d3234a9d67096a7ad23a3'

  depends_on SnowLeopardOrNewer.new

  def install
    bin.install 'bin/phantomjs'
  end
end
