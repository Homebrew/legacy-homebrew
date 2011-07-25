require 'formula'

class NCurses < Formula
  url 'http://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz'
  md5 '8cb9c412e5f2d96bc6f459aa8c6282a1'
  homepage 'http://www.gnu.org/s/ncurses/'

  def install
    system './configure', '--with-shared', \
                          '--without-debug', '--enable-widec', \
                          '--enable-const', '--enable-ext-colors', \
                          '--enable-sigwinch', '--enable-wgetch-events', \
                          "--prefix=#{prefix}"
    system 'make install'
  end
end
