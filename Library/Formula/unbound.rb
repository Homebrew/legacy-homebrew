require 'formula'

class Unbound < Formula
  homepage 'http://www.unbound.net'
  url 'http://www.unbound.net/downloads/unbound-1.4.17.tar.gz'
  sha256 '2637d6bda4065d7abf1cd11ee25bfc8e916241153c2d331de99ab6c63df5e3d3'

  depends_on 'ldns'

  def install
    # gost requires OpenSSL >= 1.0.0, and support built into ldns
    system "./configure", "--prefix=#{prefix}",
                          "--disable-gost"
    system "make install"
  end
end
