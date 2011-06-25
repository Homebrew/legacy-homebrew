require 'formula'

class Ngircd < Formula
  url 'ftp://ngircd.barton.de/pub/ngircd/ngircd-16.tar.gz'
  md5 '8c9e0382cd982b0ca77c05528ebe28eb'
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
