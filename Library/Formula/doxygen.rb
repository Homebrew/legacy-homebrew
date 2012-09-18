require 'formula'

class Doxygen < Formula
  homepage 'http://www.doxygen.org/'
  url 'http://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.1.2.src.tar.gz'
  sha1 'a11e65a597019510051290d2af0e6f379838b9c5'

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
