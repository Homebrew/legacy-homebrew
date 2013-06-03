require 'formula'

class Vim < Formula
  homepage 'http://www.vim.org/'
  # This package tracks debian-unstable: http://packages.debian.org/unstable/vim
  url 'http://ftp.de.debian.org/debian/pool/main/v/vim/vim_7.3.923.orig.tar.gz'
  sha1 'f308d219dd9c6b56e84109ace4e7487a101088f5'
  head 'https://vim.googlecode.com/hg/'

  # We only have special support for finding depends_on :python, but not yet for
  # :ruby, :perl etc., so we use the standard environment that leaves the
  # PATH as the user has set it right now.
  env :std

  depends_on :hg => :build if build.head?

  LANGUAGES         = %w(lua mzscheme perl python python3 tcl ruby)
  DEFAULT_LANGUAGES = %w(ruby python)

  option "override-system-vi", "Override system vi"
  LANGUAGES.each do |language|
    option "with-#{language}", "Build vim with #{language} support"
    option "without-#{language}", "Build vim without #{language} support"
  end

  depends_on :python unless build.without? 'python'
  depends_on :python3 if build.with? 'python3'

  option "disable-nls", "Build vim without National Language Support (translated messages, keymaps)"

  def install
    ENV['LUA_PREFIX'] = HOMEBREW_PREFIX

    language_opts = LANGUAGES.map do |language|
      if DEFAULT_LANGUAGES.include? language and !build.include? "without-#{language}"
        "--enable-#{language}interp"
      elsif build.include? "with-#{language}"
        "--enable-#{language}interp"
      end
    end.compact

    opts = language_opts
    opts << "--disable-nls" if build.include? "disable-nls"

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
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--enable-cscope",
                          "--with-features=huge",
                          *opts
    system "make"
    # If stripping the binaries is not enabled, vim will segfault with
    # statically-linked interpreters like ruby
    # http://code.google.com/p/vim/issues/detail?id=114&thanks=114&ts=1361483471
    system "make", "install", "prefix=#{prefix}", "STRIP=/usr/bin/true"
    ln_s bin+'vim', bin+'vi' if build.include? 'override-system-vi'
  end
end
