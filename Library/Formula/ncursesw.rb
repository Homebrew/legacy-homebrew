require 'formula'

class Ncursesw <Formula
  url 'http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.7.tar.gz'
  md5 'cce05daf61a64501ef6cd8da1f727ec6'
  homepage 'http://www.gnu.org/software/ncurses/ncurses.html'

  def install
    fails_with_llvm
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-widec",
                          "--disable-rpath",
                          "--with-shared",
                          "--without-ada",
                          "--enable-safe-sprintf",
                          "--enable-sigwinch",
                          "--enable-ext-colors"
    system "make install"
  end
end
