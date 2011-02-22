require 'formula'

class Vim < Formula
  url 'ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2'
  version '7.3.125'
  md5 '5b9510a17074e2b37d8bb38ae09edbf2'
  head 'https://vim.googlecode.com/hg/', :using => :hg
  homepage 'http://www.vim.org'

  def patches
      {
          :p0 => (1..125).map do |x|
              sprintf('ftp://ftp.vim.org/pub/vim/patches/7.3/7.3.%03d', x)
          end
      }
  end

  def install
    options = %w(--with-features=big --disable-gpm --enable-acl --without-x --disable-gui --disable-nls --enable-multibyte --enable-rubyinterp --enable-pythoninterp --enable-cscope --enable-perlinterp --with-tlib=ncurses)
    Dir.chdir('src') do
      system 'make', 'autoconf'
    end
    system "./configure", "--prefix=#{prefix}", *options
    system 'make', '-j3'
    system 'make', 'install'
  end
end
