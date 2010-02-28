require 'formula'

class Ngircd <Formula
  url 'ftp://ngircd.barton.de/pub/ngircd/ngircd-15.tar.gz'
  md5 'c183a85eba6fe51255983848f099c8ae'
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
