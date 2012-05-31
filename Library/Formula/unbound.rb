require 'formula'

class Unbound < Formula
  homepage 'http://www.unbound.net'
  url 'http://www.unbound.net/downloads/unbound-1.4.16.tar.gz'
  sha256 'fb71665851eb11d3b1ad5dd5f9d7b167e0902628c06db3d6fc14afd95cc970fa'

  depends_on 'ldns'

  def install
    system "./configure", "--disable-gost", "--prefix=#{prefix}"
    system "make install"
  end
end
