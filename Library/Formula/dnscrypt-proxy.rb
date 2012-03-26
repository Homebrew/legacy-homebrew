require 'formula'

class DnscryptProxy < Formula
  url 'https://github.com/downloads/opendns/dnscrypt-proxy/dnscrypt-proxy-0.8.tar.gz'
  head 'https://github.com/opendns/dnscrypt-proxy.git', :branch => 'master'
  homepage 'http://www.opendns.com/technology/dnscrypt'
  md5 '9c573da27aa897f27a564214c92bcddb'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
