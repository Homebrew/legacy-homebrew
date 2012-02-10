require 'formula'

class Doxygen < Formula
  homepage 'http://www.doxygen.org/'
  url 'http://ftp.stack.nl/pub/users/dimitri/doxygen-1.7.6.1.src.tar.gz'
  sha1 '6203d4423d12315f1094b56a4d7393347104bc4a'

  head 'https://doxygen.svn.sourceforge.net/svnroot/doxygen/trunk'

  def install
    system "./configure", "--prefix", prefix
    system "make", "CC=#{ENV.cc}",
                   "CXX=#{ENV.cxx}",
                   "CFLAGS=#{ENV.cflags}",
                   "CXXFLAGS=#{ENV.cflags}"
    # MAN1DIR, relative to the given prefix
    system "make", "MAN1DIR=share/man/man1", "install"
  end
end
