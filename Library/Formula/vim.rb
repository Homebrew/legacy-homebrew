require 'formula'

class Vim < Formula
  homepage 'http://www.vim.org/'
  # Get stable versions from hg repo instead of downloading an increasing
  # number of separate patches.
  url 'https://vim.googlecode.com/hg/', :tag => 'v7-3-692'
  version '7.3.692'

  head 'https://vim.googlecode.com/hg/'

  def install
    # Why are we specifying HOMEBREW_PREFIX as the prefix?
    #
    # To make vim look for the system vimscript files in the
    # right place, we need to tell it about HOMEBREW_PREFIX.
    # The actual install location will still be in the Cellar.
    #
    # This way, user can create /usr/local/share/vim/vimrc
    # or /usr/local/share/vim/vimfiles and they won't end up
    # in the Cellar, and be removed when vim is upgraded.
    system "./configure", "--prefix=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}",
                          "--enable-gui=no",
                          "--without-x",
                          "--disable-nls",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--enable-pythoninterp",
                          "--enable-rubyinterp",
                          "--enable-cscope",
                          "--with-features=huge"
    system "make"

    # Even though we specified HOMEBREW_PREFIX for configure,
    # we still want to install it in the Cellar location.
    system "make", "install", "prefix=#{prefix}"
  end
end
