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
  url 'http://phantomjs.googlecode.com/files/phantomjs-1.7.0-macosx.zip'
  sha1 'de9ed8092d7fd5095447ada2cf96efb6c949b359'

  depends_on SnowLeopardOrNewer.new

  def install
    bin.install 'bin/phantomjs'
  end
end
