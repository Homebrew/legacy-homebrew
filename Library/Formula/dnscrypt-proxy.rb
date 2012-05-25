require 'formula'

class DnscryptProxy < Formula
  homepage 'http://www.opendns.com/technology/dnscrypt'
  url 'https://github.com/downloads/opendns/dnscrypt-proxy/dnscrypt-proxy-0.9.4.tar.gz'
  md5 'c997fd1322ac5aef8325a718da7d73e2'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
