require 'formula'

class SnowLeopardOrNewer < Requirement
  def satisfied?
    MacOS.version >= :snow_leopard
  end

  def message
    "PhantomJS requires Mac OS X 10.6 (Snow Leopard) or newer."
  end
end

class Phantomjs < Formula
  homepage 'http://www.phantomjs.org/'
  url 'http://phantomjs.googlecode.com/files/phantomjs-1.8.1-macosx.zip'
  sha1 '69206ce980703e54160628614a6917d8ec19c281'

  depends_on SnowLeopardOrNewer.new

  def install
    bin.install 'bin/phantomjs'
  end
end
