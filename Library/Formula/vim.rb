require 'formula'

class Vim <Formula
  url 'ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2'
  homepage 'http://www.vim.org'
  md5 '5b9510a17074e2b37d8bb38ae09edbf2'

  depends_on 'cmake'

  def install
    system "./configure", "--enable-rubyinterp", "--enable-pythoninterp",
    "--with-features=huge", "--disable-debug", "--disable-dependency-tracking",
    "--prefix=#{prefix}"

    system "make install"
  end
end