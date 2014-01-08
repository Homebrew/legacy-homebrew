require 'formula'

class Ngircd < Formula
  homepage 'http://ngircd.barton.de'
  url 'ftp://ftp.berlios.de/pub/ngircd/ngircd-21.tar.gz'
  mirror 'http://ngircd.barton.de/pub/ngircd/ngircd-21.tar.gz'
  sha256 '0edbd41304186e43f9d907a7017b40520cc90c2ce29b1339bdcd7622fffe19a0'

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
