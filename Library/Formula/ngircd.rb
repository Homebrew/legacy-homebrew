require 'formula'

class Ngircd < Formula
  homepage 'http://ngircd.barton.de'

  url 'ftp://ftp.berlios.de/pub/ngircd/ngircd-19.1.tar.gz'
  mirror 'http://ngircd.barton.de/pub/ngircd/ngircd-19.1.tar.gz'
  md5 'baa653d4877ea5b24af64859115e00f8'

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
