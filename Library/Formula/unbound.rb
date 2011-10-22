require 'formula'

class Unbound < Formula
  url 'http://www.unbound.net/downloads/unbound-1.4.13.tar.gz'
  homepage 'http://www.unbound.net'
  sha1 '834ccfd1cb41a44f53b33f8338a8f9cc68febaf7'

  depends_on 'ldns'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-gost"
    system "make install"
  end
end
