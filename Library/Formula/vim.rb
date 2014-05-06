require 'formula'

class Vim < Formula
  homepage 'http://www.vim.org/'
  head 'https://vim.googlecode.com/hg/'
  # This package tracks debian-unstable: http://packages.debian.org/unstable/vim
  url 'http://ftp.debian.org/debian/pool/main/v/vim/vim_7.4.273.orig.tar.gz'
  sha1 '87da49006fbea912b5bf5f99cc91030581b43269'

  # We only have special support for finding depends_on :python, but not yet for
  # :ruby, :perl etc., so we use the standard environment that leaves the
  # PATH as the user has set it right now.
  env :std

  option "override-system-vi", "Override system vi"
  option "disable-nls", "Build vim without National Language Support (translated messages, keymaps)"
  option "with-client-server", "Enable client/server mode"

  LANGUAGES_OPTIONAL = %w(lua mzscheme perl python3 tcl)
  LANGUAGES_DEFAULT  = %w(ruby python)

  LANGUAGES_OPTIONAL.each do |language|
    option "with-#{language}", "Build vim with #{language} support"
  end
  LANGUAGES_DEFAULT.each do |language|
    option "without-#{language}", "Build vim without #{language} support"
  end

  depends_on :python => :recommended
  depends_on 'python3' => :optional
  depends_on 'lua' => :optional
  depends_on 'luajit' => :optional
  depends_on 'gtk+' if build.with? 'client-server'

  conflicts_with 'ex-vi',
    :because => 'vim and ex-vi both install bin/ex and bin/view'

  def install
    ENV['LUA_PREFIX'] = HOMEBREW_PREFIX if build.with?('lua')

    # vim doesn't require any Python package, unset PYTHONPATH.
    ENV.delete('PYTHONPATH')

    opts = []
    opts += LANGUAGES_OPTIONAL.map do |language|
      "--enable-#{language}interp" if build.with? language
    end
    opts += LANGUAGES_DEFAULT.map do |language|
      "--enable-#{language}interp" if build.with? language
    end
    if opts.include? "--enable-pythoninterp" and opts.include? "--enable-python3interp"
      opts = opts - %W[--enable-pythoninterp --enable-python3interp] + %W[--enable-pythoninterp=dynamic --enable-python3interp=dynamic]
    end

    opts << "--disable-nls" if build.include? "disable-nls"

    if build.with? 'client-server'
      opts << '--enable-gui=gtk2'
    else
      opts << "--enable-gui=no"
      opts << "--without-x"
    end

    opts << "--with-luajit" if build.with? 'luajit'

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
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--enable-cscope",
                          "--with-features=huge",
                          "--with-compiledby=Homebrew",
                          *opts

    system "make"
    # If stripping the binaries is not enabled, vim will segfault with
    # statically-linked interpreters like ruby
    # http://code.google.com/p/vim/issues/detail?id=114&thanks=114&ts=1361483471
    system "make", "install", "prefix=#{prefix}", "STRIP=true"
    bin.install_symlink "vim" => "vi" if build.include? "override-system-vi"
  end

  def caveats
    s = ''
    if build.with? "python" and build.with? "python3"
      s += <<-EOS.undent
        Vim has been built with dynamic loading of Python 2 and Python 3.

        Note: if Vim dynamically loads both Python 2 and Python 3, it may
        crash. For more information, see:
            http://vimdoc.sourceforge.net/htmldoc/if_pyth.html#python3
      EOS
    end
  end
end
