require 'formula'

class Vim <Formula
  url 'ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2'
  homepage 'http://www.vim.org/'
  md5 '5b9510a17074e2b37d8bb38ae09edbf2'

  def install
    system "./configure", "--enable-perlinterp",
                          "--enable-pythoninterp",
                          "--enable-rubyinterp",
                          "--enable-gui=no",
                          "--disable-gpm",
                          "--with-ruby-command=/usr/bin/ruby",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    system "make install"
  end
end
