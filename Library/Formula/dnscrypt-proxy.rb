require 'formula'

class DnscryptProxy < Formula
  homepage 'http://www.opendns.com/technology/dnscrypt'
  url 'https://github.com/downloads/opendns/dnscrypt-proxy/dnscrypt-proxy-1.0.1.tar.gz'
  sha256 '9852a8dcae200c9965697b29fdaffb8ee1dc8602420afdb8763811a7996d6a7f'

  head 'https://github.com/opendns/dnscrypt-proxy.git', :branch => '1.0.x'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
