require 'formula'

class Bison <Formula
  url 'http://ftp.gnu.org/gnu/bison/bison-2.4.3.tar.bz2'
  homepage 'http://www.gnu.org/software/bison/'
  md5 'c1d3ea81bc370dbd43b6f0b2cd21287e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
