require 'formula'

class Privoxy < Formula
  url 'http://downloads.sourceforge.net/project/ijbswa/Sources/3.0.18%20%28stable%29/privoxy-3.0.18-stable-src.tar.gz'
  homepage 'http://www.privoxy.org'
  version '3.0.18'
  md5 'baf0b13bb591ec6e1ba15b720ddea65c'

  def install
    system "autoreconf -i"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/privoxy"
    system "make"
    system "make install"
  end
end
