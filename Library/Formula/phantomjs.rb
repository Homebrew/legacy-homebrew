require 'formula'

class SnowLeopardOrNewer < Requirement
  satisfy MacOS.version >= :snow_leopard

  def message
    "PhantomJS requires Mac OS X 10.6 (Snow Leopard) or newer."
  end
end

class Phantomjs < Formula
  homepage 'http://www.phantomjs.org/'
  url 'http://phantomjs.googlecode.com/files/phantomjs-1.9.1-macosx.zip'
  sha1 '9c165cd1eb79fcb535a315ae096da4c0f0f8f6a2'

  depends_on SnowLeopardOrNewer

  def install
    bin.install 'bin/phantomjs'
    (share+'phantomjs').install 'examples'
  end
end
