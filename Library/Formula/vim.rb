require 'formula'

class Vim <Formula
  # Get stable versions from hg repo instead of downloading an increasing
  # number of separate patches.
  url 'https://vim.googlecode.com/hg/', :revision => '763272b18e4ffe717ebb58827315badc09824e86'
  version '7.3.098'
  homepage 'http://www.vim.org/'

  head 'https://vim.googlecode.com/hg/'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-gui=no",
                          "--without-x",
                          "--disable-nls",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          #"--enable-pythoninterp",
                          #"--enable-rubyinterp",
                          "--with-features=huge"
    system "make"
    system "make install"
  end
end
