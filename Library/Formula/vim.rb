class Vim < Formula
  desc "Vi \"workalike\" with many additional features"
  homepage "http://www.vim.org/"
  bottle do
    sha256 "786f8bea2ed0ce1c3ab6a9ae2d445ea4e8af7c9702a6c7654675837d10673b00" => :el_capitan
    sha256 "a54e42b2114557bd2c9700a840b65bbc6ff7e3ae633e3f9d03181e5048043fd3" => :yosemite
    sha256 "4ba52d1671798273453fa232c98b2ccf191347bba7482fd54ead3114e72b6bb7" => :mavericks
  end

  # *** Vim should be updated no more than once every 7 days ***
  url "https://github.com/vim/vim/archive/v7.4.889.tar.gz"
  sha256 "b4247eb470e965a5fc08989b26ad30998b7f3efce1d5a5001b85666ee26ee4f3"
  head "https://github.com/vim/vim.git"

  # We only have special support for finding depends_on :python, but not yet for
  # :ruby, :perl etc., so we use the standard environment that leaves the
  # PATH as the user has set it right now.
  env :std

  option "override-system-vi", "Override system vi"
  option "disable-nls", "Build vim without National Language Support (translated messages, keymaps)"
  option "with-client-server", "Enable client/server mode"

  LANGUAGES_OPTIONAL = %w[lua mzscheme python3 tcl]
  LANGUAGES_DEFAULT  = %w[perl python ruby]

  option "with-python3", "Build vim with python3 instead of python[2] support"
  LANGUAGES_OPTIONAL.each do |language|
    option "with-#{language}", "Build vim with #{language} support"
  end
  LANGUAGES_DEFAULT.each do |language|
    option "without-#{language}", "Build vim without #{language} support"
  end

  depends_on :python => :recommended
  depends_on :python3 => :optional
  depends_on "lua" => :optional
  depends_on "luajit" => :optional
  depends_on :x11 if build.with? "client-server"

  conflicts_with "ex-vi",
    :because => "vim and ex-vi both install bin/ex and bin/view"

  def install
    ENV["LUA_PREFIX"] = HOMEBREW_PREFIX if build.with?("lua") || build.with?("luajit")

    # vim doesn't require any Python package, unset PYTHONPATH.
    ENV.delete("PYTHONPATH")

    if build.with?("python") && which("python").to_s == "/usr/bin/python" && !MacOS.clt_installed?
      # break -syslibpath jail
      ln_s "/System/Library/Frameworks", buildpath
      ENV.append "LDFLAGS", "-F#{buildpath}/Frameworks"
    end

    opts = []

    (LANGUAGES_OPTIONAL + LANGUAGES_DEFAULT).each do |language|
      opts << "--enable-#{language}interp" if build.with? language
    end

    if opts.include?("--enable-pythoninterp") && opts.include?("--enable-python3interp")
      # only compile with either python or python3 support, but not both
      # (if vim74 is compiled with +python3/dyn, the Python[3] library lookup segfaults
      # in other words, a command like ":py3 import sys" leads to a SEGV)
      opts -= %W[--enable-pythoninterp]
    end

    opts << "--disable-nls" if build.include? "disable-nls"
    opts << "--enable-gui=no"

    if build.with? "client-server"
      opts << "--with-x"
    else
      opts << "--without-x"
    end

    if build.with? "luajit"
      opts << "--with-luajit"
      opts << "--enable-luainterp"
    end

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
    # If stripping the binaries is enabled, vim will segfault with
    # statically-linked interpreters like ruby
    # http://code.google.com/p/vim/issues/detail?id=114&thanks=114&ts=1361483471
    system "make", "install", "prefix=#{prefix}", "STRIP=true"
    bin.install_symlink "vim" => "vi" if build.include? "override-system-vi"
  end

  test do
    # Simple test to check if Vim was linked to Python version in $PATH
    if build.with? "python"
      vim_path = bin/"vim"

      # Get linked framework using otool
      otool_output = `otool -L #{vim_path} | grep -m 1 Python`.gsub(/\(.*\)/, "").strip.chomp

      # Expand the link and get the python exec path
      vim_framework_path = Pathname.new(otool_output).realpath.dirname.to_s.chomp
      system_framework_path = `python-config --exec-prefix`.chomp

      assert_equal system_framework_path, vim_framework_path
    end
  end
end
