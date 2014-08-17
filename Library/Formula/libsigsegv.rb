require 'formula'

class Libsigsegv < Formula
  homepage 'http://www.gnu.org/software/libsigsegv/'
  url 'http://ftpmirror.gnu.org/libsigsegv/libsigsegv-2.10.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libsigsegv/libsigsegv-2.10.tar.gz'
  sha256 '8460a4a3dd4954c3d96d7a4f5dd5bc4d9b76f5754196aa245287553b26d2199a'

  bottle do
    cellar :any
    sha1 "9b41705338724002198da13588a26a4a424609f4" => :mavericks
    sha1 "7684a990f71233442d9ee1d999138dcabc144bb5" => :mountain_lion
    sha1 "ef78c9e5ee034cdb78f77c2cb130dd578bc9b327" => :lion
  end

  fails_with :llvm do
    build 2336
    cause "Fails make check with LLVM GCC from XCode 4 on Snow Leopard"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make check"
    system "make install"
  end
end
