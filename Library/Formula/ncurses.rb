require 'formula'

class Ncurses <Formula
  url 'http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.7.tar.gz'
  homepage 'http://www.gnu.org/software/ncurses/'
  md5 'cce05daf61a64501ef6cd8da1f727ec6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-echo",
                          "--without-ada",
                          "--enable-widec",
                          # tic doesn't link correctly
                          "--without-progs"
    system "make install"
  end
end
