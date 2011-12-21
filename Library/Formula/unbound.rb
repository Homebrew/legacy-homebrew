require 'formula'

class Unbound < Formula
  url 'http://www.unbound.net/downloads/unbound-1.4.14.tar.gz'
  homepage 'http://www.unbound.net'
  md5 'cd69fdaaa6af01ea0b6fbc59802f74ba'

  depends_on 'ldns'

  def install
    system "./configure", "--disable-gost", "--prefix=#{prefix}"
    system "make install"
  end
end
