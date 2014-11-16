require 'formula'

class Zsh5Installed < Requirement
  default_formula 'zsh'
  fatal true

  satisfy :build_env => false do
    `zsh --version`[/zsh (\d)/, 1] == "5" rescue false
  end

  def message
    "Zsh 5.x is required to install. Consider `brew install zsh`."
  end
end

class Zpython < Formula
  homepage 'https://bitbucket.org/ZyX_I/zsh'

  stable do
    url "https://downloads.sourceforge.net/project/zsh/zsh/5.0.5/zsh-5.0.5.tar.bz2"
    mirror "http://www.zsh.org/pub/zsh-5.0.5.tar.bz2"

    # Note, non-head version is completly implemented in this lengthy patch
    # later on, we hope to use https://bitbucket.org/ZyX_I/zsh.git to download a tagged release.
    patch do
      url "https://gist.githubusercontent.com/felixbuenemann/5790777/raw/cb5ea3b34617174e50fd3972792ec0944959de3c/zpython.patch"
      sha1 "b6ebdaf5f18da9c152f17f9a93987596a37fbf14"
    end
  end

  # We prepend `00-` for the first version of the zpython module, which is
  # itself a patch on top of zsh and does not have own version number yes.
  # Hoping that upstream will provide tags that we could download properly.
  # Starting here with `00-`, so that once we get tags for the upstream
  # repository at https://bitbucket.org/ZyX_I/zsh.git, brew outdated will
  # be able to tell us to upgrade zpython.
  version '00-5.0.5'
  sha1 '75426146bce45ee176d9d50b32f1ced78418ae16'

  head 'https://bitbucket.org/ZyX_I/zsh.git', :branch => 'zpython'

  depends_on Zsh5Installed
  depends_on "autoconf" => :build

  def install
    args = %W[
      --disable-gdbm
      --enable-zpython
      --with-tcsetpgrp
    ]

    system "autoreconf"
    system "./configure", *args

    # Disable building docs due to exotic yodl dependency
    inreplace "Makefile", "subdir in Src Doc;", "subdir in Src;"

    system "make"
    (lib/"zpython/zsh").install "Src/Modules/zpython.so"
  end

  test do
    system "zsh -c 'MODULE_PATH=#{HOMEBREW_PREFIX}/lib/zpython zmodload zsh/zpython && zpython print'"
  end

  def caveats; <<-EOS.undent
    To use the zpython module in zsh you need to
    add the following line to your .zshrc:

      module_path=($module_path #{HOMEBREW_PREFIX}/lib/zpython)

    If you want to use this with powerline, make sure you set
    it early in .zshrc, before your prompt gets initialized.

    After reloading your shell you can test with:
      zmodload zsh/zpython && zpython 'print "hello world"'
    EOS
  end
end
