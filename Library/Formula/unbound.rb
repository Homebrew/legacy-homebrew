require 'formula'

class Unbound < Formula
  url 'http://www.unbound.net/downloads/unbound-1.4.13.tar.gz'
  homepage 'http://www.unbound.net'
  md5 '7e3b27dee2b97640dd2e1783253317ab'

  depends_on 'ldns'

  def install
    system "./configure", "--disable-gost", "--disable-sha2", "--with-ssl-optional",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
