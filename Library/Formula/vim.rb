require 'formula'

class Vim <Formula
  # Get patch-level 411 from Subversion, because downloading and applying 411 separate patches
  # is completely ridiculous.
  head 'http://vim.svn.sourceforge.net/svnroot/vim/branches/vim7.2/', :revision => '1827'
  version '7.2.411'
  homepage 'http://www.vim.org/'
  
  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-gui=no",
                          "--without-x",
                          "--disable-nls",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--enable-pythoninterp",
                          "--enable-rubyinterp"
    system "make"
    system "make install"
  end
end
