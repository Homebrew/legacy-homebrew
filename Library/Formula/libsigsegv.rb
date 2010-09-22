require 'formula'

class Libsigsegv <Formula
  url 'ftp://ftp.gnu.org/pub/gnu/libsigsegv/libsigsegv-2.6.tar.gz'
  homepage 'http://libsigsegv.sourceforge.net/'
  md5 '7e24993730649d13c6eabc28bd24de35'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end
end
