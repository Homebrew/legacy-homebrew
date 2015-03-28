require 'formula'

class Potrace < Formula
  homepage 'http://potrace.sourceforge.net'
  url 'http://potrace.sourceforge.net/download/1.12/potrace-1.12.tar.gz'
  sha1 'e66bd7d6ff74fe45a07d4046f6303dec5d23847f'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libpotrace"
    system "make install"
  end
end
