require 'formula'

class Vim < Formula
  url 'ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2'
  version 'v7.3'
  md5 '5b9510a17074e2b37d8bb38ae09edbf2'
  homepage 'http://http://www.vim.org'

  def options
    [["--with-cscope", "Build with Cscope support."]]
  end

  depends_on 'cscope' if ARGV.include? '--with-cscope'

  def install
    args = [
      "--with-features=huge",
      "--enable-perlinterp",
      "--enable-pythoninterp",
      "--enable-rubyinterp",
      "--enable-tclinterp"
    ]

    if ARGV.include? "--with-cscope"
      args << "--enable-cscope"
    end

    system "./configure", *args
    system "make"
    system "make install"
  end
end
