require 'formula'

class Doxygen <Formula
  url 'http://ftp.stack.nl/pub/users/dimitri/doxygen-1.7.2.src.tar.gz'
  homepage 'http://www.doxygen.org/'
  md5 'd5f3e32474186abc64288db6b8ffd7f0'

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
