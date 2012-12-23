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
  url 'http://phantomjs.googlecode.com/files/phantomjs-1.8.0-macosx.zip'
  sha1 'c54cb3bbeda39a7d332d92d79dc64971785876cc'

  depends_on SnowLeopardOrNewer.new

  def install
    bin.install 'bin/phantomjs'
  end
end
