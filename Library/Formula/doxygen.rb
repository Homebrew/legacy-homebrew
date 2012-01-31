require 'formula'

class Doxygen < Formula
  url 'http://ftp.stack.nl/pub/users/dimitri/doxygen-1.7.6.1.src.tar.gz'
  sha1 '6203d4423d12315f1094b56a4d7393347104bc4a'
  homepage 'http://www.doxygen.org/'
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
