require 'formula'

class Libsigsegv < Formula
  url 'http://ftp.gnu.org/pub/gnu/libsigsegv/libsigsegv-2.8.tar.gz'
  homepage 'http://www.gnu.org/software/libsigsegv/'
  md5 'ebe554e26870d8bc200ef3e3539ffd7c'

  fails_with_llvm "Fails during configure with LLVM GCC from XCode 4 on Snow Leopard"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end
end
