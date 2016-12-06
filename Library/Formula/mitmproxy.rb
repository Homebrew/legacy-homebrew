require 'formula'

class Mitmproxy < Formula
  homepage 'http://mitmproxy.org/'
  url 'http://mitmproxy.org/download/osx-mitmproxy-0.9.2.tar.gz'
  sha1 '6abb2ade46b96005e8543370230220ed5408b315'

  def install
    bin.install 'mitmproxy', 'mitmdump'
  end
end
