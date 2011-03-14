require 'formula'

class Doxygen < Formula
  url 'http://ftp.stack.nl/pub/users/dimitri/doxygen-1.7.3.src.tar.gz'
  homepage 'http://www.doxygen.org/'
  md5 '6cc5ad566dbec5cf843dc600b1162808'
  head 'https://doxygen.svn.sourceforge.net/svnroot/doxygen/trunk'

  def install
    system "./configure", "--prefix", prefix
    inreplace "Makefile" do |s|
      # Path of man1 relative to already given prefix
      s.change_make_var! 'MAN1DIR', 'share/man/man1'
    end
    system "make"
    system "make install"
  end
end
