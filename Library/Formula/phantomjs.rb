require 'formula'

class SnowLeopardOrNewer < Requirement
  satisfy MacOS.version >= :snow_leopard

  def message
    "PhantomJS requires Mac OS X 10.6 (Snow Leopard) or newer."
  end
end

class Phantomjs < Formula
  homepage 'http://www.phantomjs.org/'
  url 'http://phantomjs.googlecode.com/files/phantomjs-1.9.0-macosx.zip'
  sha1 '784772eb8d01d26f86e474a410b0f820b6a65a6c'

  depends_on SnowLeopardOrNewer

  def install
    bin.install 'bin/phantomjs'
    (share+'phantomjs').install 'examples'
  end
end
