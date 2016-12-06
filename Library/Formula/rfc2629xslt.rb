require 'formula'

class Rfc2629xslt < Formula
  homepage 'http://greenbytes.de/tech/webdav/rfc2629xslt/rfc2629xslt.html'
  url 'http://greenbytes.de/tech/webdav/rfc2629xslt.zip'
  md5 '4ff274e48ae0f73664b95f20241231b3'
  version 'rfc2629xslt'

  def install
    system "mkdir rfc2629xslt; mv *.* rfc2629xslt/"
    share.install Dir['*']
  end

  def test
    system "false"
  end
end
