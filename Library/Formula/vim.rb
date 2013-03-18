require 'formula'

class Vim < Formula
  homepage 'http://www.vim.org/'
  # Get stable versions from hg repo instead of downloading an increasing
  # number of separate patches.
  url 'https://vim.googlecode.com/hg/', :tag => 'v7-3-865'
  version '7.3.865'

  head 'https://vim.googlecode.com/hg/'

  env :std # To find interpreters

  LANGUAGES         = %w(lua mzscheme perl python python3 tcl ruby)
  DEFAULT_LANGUAGES = %w(ruby python)

  LANGUAGES.each do |language|
    option "with-#{language}", "Build vim with #{language} support"
    option "without-#{language}", "Build vim without #{language} support"
  end

  def install
    ENV['LUA_PREFIX'] = HOMEBREW_PREFIX

    language_opts = LANGUAGES.map do |language|
      if DEFAULT_LANGUAGES.include? language and !build.include? "without-#{language}"
        "--enable-#{language}interp"
      elsif build.include? "with-#{language}"
        "--enable-#{language}interp"
      end
    end.compact

    # XXX: Please do not submit a pull request that hardcodes the path
    # to ruby: vim can be compiled against 1.8.x or 1.9.3-p385 and up.
    # If you have problems with vim because of ruby, ensure a compatible
    # version is first in your PATH when building vim.

    # We specify HOMEBREW_PREFIX as the prefix to make vim look in the
    # the right place (HOMEBREW_PREFIX/share/vim/{vimrc,vimfiles}) for
    # system vimscript files. We specify the normal installation prefix
    # when calling "make install".
    system "./configure", "--prefix=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}",
                          "--enable-gui=no",
                          "--without-x",
                          "--disable-nls",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--enable-cscope",
                          "--with-features=huge",
                          *language_opts
    system "make"
    # If stripping the binaries is not enabled, vim will segfault with
    # statically-linked interpreters like ruby
    # http://code.google.com/p/vim/issues/detail?id=114&thanks=114&ts=1361483471
    system "make", "install", "prefix=#{prefix}", "STRIP=/usr/bin/true"
  end
end
