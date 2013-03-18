require 'formula'

class SnowLeopardOrNewer < Requirement
  satisfy MacOS.version >= :snow_leopard

  def message
    "PhantomJS requires Mac OS X 10.6 (Snow Leopard) or newer."
  end
end

class Phantomjs < Formula
  homepage 'http://www.phantomjs.org/'
  url 'http://phantomjs.googlecode.com/files/phantomjs-1.8.2-macosx.zip'
  sha1 '904a89cd5df585e69cba20c6502e5c6d32b3be86'

  depends_on SnowLeopardOrNewer

  def install
    bin.install 'bin/phantomjs'
    (share+'phantomjs').install 'examples'
  end
end
