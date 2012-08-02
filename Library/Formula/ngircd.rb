require 'formula'

class Ngircd < Formula
  homepage 'http://ngircd.barton.de'
  url 'ftp://ftp.berlios.de/pub/ngircd/ngircd-19.2.tar.gz'
  mirror 'http://ngircd.barton.de/pub/ngircd/ngircd-19.2.tar.gz'
  sha1 'c97e0409778ef1a4431bec1917b36918171047bc'

  depends_on 'libident'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ident",
                          "--with-openssl",
                          "--with-tcp-wrappers",
                          "--enable-ipv6"
    system "make install"
  end
end
