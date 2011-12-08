require 'formula'

class DnscryptProxy < Formula
  url 'https://github.com/downloads/opendns/dnscrypt-proxy/dnscrypt-proxy-0.7.tar.gz'
  homepage 'http://www.opendns.com/technology/dnscrypt'
  md5 'cfde647dbcaa6b11f7b3c645bb866434'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make -j2"
    system "make install"
  end

  def test
    system "dnscrypt-proxy --daemonize"
  end
end
