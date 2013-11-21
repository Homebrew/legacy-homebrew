require 'formula'

class Ngircd < Formula
  homepage 'http://ngircd.barton.de'
  url 'ftp://ftp.berlios.de/pub/ngircd/ngircd-20.2.tar.gz'
  mirror 'http://ngircd.barton.de/pub/ngircd/ngircd-20.2.tar.gz'
  sha1 'f66037ea6a8ceb20904e0a37de9ce0bf31f27d47'

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
