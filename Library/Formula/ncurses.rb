require 'formula'

class Ncurses < Formula
  homepage 'http://www.gnu.org/software/ncurses/'
  url 'http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.9.tar.gz'
  md5 '8cb9c412e5f2d96bc6f459aa8c6282a1'

  def install
   system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
