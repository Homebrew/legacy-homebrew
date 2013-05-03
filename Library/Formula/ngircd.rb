require 'formula'

class Ngircd < Formula
  homepage 'http://ngircd.barton.de'
  url 'ftp://ftp.berlios.de/pub/ngircd/ngircd-20.1.tar.gz'
  mirror 'http://ngircd.barton.de/pub/ngircd/ngircd-20.1.tar.gz'
  sha1 'e5dcbd3c40880b951854c10ed52e3c1dc17c3fe0'

  depends_on 'libident'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ident",
                          "--with-openssl",
                          "--enable-ipv6"
    system "make install"
  end
end
