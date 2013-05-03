require 'formula'

class Potrace < Formula
  homepage 'http://potrace.sourceforge.net'
  url 'http://potrace.sourceforge.net/download/potrace-1.11.tar.gz'
  sha1 '7296baf27bf35298263cb3ed3df34a38fed0b441'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libpotrace"
    system "make install"
  end
end
