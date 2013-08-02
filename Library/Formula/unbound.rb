require 'formula'

class Unbound < Formula
  homepage 'http://www.unbound.net'
  url 'http://www.unbound.net/downloads/unbound-1.4.20.tar.gz'
  sha1 '1752976533be2a4f0c9cdbab9d2cbb67d4f27c43'

  depends_on 'ldns'

  def install
    # gost requires OpenSSL >= 1.0.0, and support built into ldns
    system "./configure", "--prefix=#{prefix}",
                          "--disable-gost"
    system "make install"
  end
end
