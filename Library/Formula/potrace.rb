require 'formula'

class Potrace < Formula
  homepage 'http://potrace.sourceforge.net'
  url 'http://potrace.sourceforge.net/download/potrace-1.10.tar.gz'
  sha1 'e6e8b64d85d30b4695d197a79187ac98c2b236f9'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libpotrace"
    system "make install"
  end
end
