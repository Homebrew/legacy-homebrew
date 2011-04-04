require 'formula'

class Valgrind < Formula
  homepage 'http://www.valgrind.org/'

  url "http://valgrind.org/downloads/valgrind-3.6.1.tar.bz2"
  md5 "2c3aa122498baecc9d69194057ca88f5"

  depends_on 'pkg-config' => :build

  fails_with_llvm "Makes applications segfault on startup", :build => 2326

  skip_clean 'lib'

  def install
    system "./autogen.sh" if File.exists? "autogen.sh"

    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    args << "--enable-only64bit" << "--build=amd64-darwin" if MacOS.prefer_64_bit?

    system "./configure", *args
    system "make install"
  end
end
