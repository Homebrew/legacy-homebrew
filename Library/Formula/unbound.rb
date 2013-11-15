require 'formula'

class Unbound < Formula
  homepage 'http://www.unbound.net'
  url 'http://www.unbound.net/downloads/unbound-1.4.21.tar.gz'
  sha1 '3ef4ea626e5284368d48ab618fe2207d43f2cee1'

  depends_on 'ldns'

  def install
    # gost requires OpenSSL >= 1.0.0, and support built into ldns
    system "./configure", "--prefix=#{prefix}",
                          "--disable-gost"
    system "make install"
  end
end
