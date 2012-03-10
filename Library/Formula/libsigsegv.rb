require 'formula'

class Libsigsegv < Formula
  url 'http://ftpmirror.gnu.org/libsigsegv/libsigsegv-2.10.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libsigsegv/libsigsegv-2.10.tar.gz'
  homepage 'http://www.gnu.org/software/libsigsegv/'
  sha256 '8460a4a3dd4954c3d96d7a4f5dd5bc4d9b76f5754196aa245287553b26d2199a'

  fails_with_llvm "Fails make check with LLVM GCC from XCode 4 on Snow Leopard", :build => 2336

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make check"
    system "make install"
  end
end
