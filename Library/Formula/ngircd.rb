require 'formula'

class Ngircd < Formula
  url 'ftp://ftp.berlios.de/pub/ngircd/ngircd-17.1.tar.gz'
  md5 'b4ad0b1f18875ff3f2e92f076e64496b'
  homepage 'http://ngircd.barton.de'

  depends_on 'libident'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ident", "--with-openssl", "--with-tcp-wrappers",
                          "--enable-ipv6"
    system "make install"
  end
end
