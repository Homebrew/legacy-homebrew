require 'formula'

class Vim < Formula
  homepage 'http://www.vim.org/'
  # Get stable versions from hg repo instead of downloading an increasing
  # number of separate patches.
  url 'https://vim.googlecode.com/hg/', :tag => 'v7-3-806'
  version '7.3.806'

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
                          "--enable-cscope",
                          "--with-features=huge",
                          *language_opts
    system "make"

    # Even though we specified HOMEBREW_PREFIX for configure,
    # we still want to install it in the Cellar location.
    system "make", "install", "prefix=#{prefix}"
  end
end
