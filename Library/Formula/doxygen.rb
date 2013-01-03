require 'formula'

class Doxygen < Formula
  homepage 'http://www.doxygen.org/'
  url 'http://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.3.src.tar.gz'
  mirror 'http://downloads.sourceforge.net/project/doxygen/rel-1.8.3/doxygen-1.8.3.src.tar.gz'
  sha1 'e74240f445e08b782fa7a3de5f0b333901307587'

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
