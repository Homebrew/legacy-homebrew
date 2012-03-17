require 'formula'

class Doxygen < Formula
  homepage 'http://www.doxygen.org/'
  url 'http://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.0.src.tar.gz'
  sha1 '7f4348418dc3efefd357b32a2b5c8010211ab284'

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
