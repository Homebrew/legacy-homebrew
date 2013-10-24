require 'formula'

class Phantomjs < Formula
  homepage 'http://www.phantomjs.org/'
  url 'http://phantomjs.googlecode.com/files/phantomjs-1.9.1-macosx.zip'
  sha1 '9c165cd1eb79fcb535a315ae096da4c0f0f8f6a2'

  depends_on :macos => :snow_leopard

  def install
    bin.install 'bin/phantomjs'
    (share+'phantomjs').install 'examples'
  end
end
