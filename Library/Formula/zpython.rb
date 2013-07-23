require 'formula'

class Zsh5Installed < Requirement
  default_formula 'zsh'
  fatal true

  satisfy :build_env => false do
    `zsh --version`[/zsh (\d)/, 1] == "5" rescue false
  end

  def message
    "Zsh 5.x is required to install."
  end
end

class Zpython < Formula
  homepage 'https://bitbucket.org/ZyX_I/zsh'
  url 'http://www.zsh.org/pub/zsh-5.0.2.tar.bz2'
  mirror 'http://sourceforge.net/projects/zsh/files/zsh/5.0.2/zsh-5.0.2.tar.bz2'
  sha1 '9f55ecaaae7cdc1495f91237ba2ec087777a4ad9'

  head 'https://bitbucket.org/ZyX_I/zsh.git', :branch => 'zpython'

  depends_on Zsh5Installed
  depends_on :python
  depends_on :autoconf => :build

  def patches
    {:p1 => "https://gist.github.com/felixbuenemann/5790777/raw/cb5ea3b34617174e50fd3972792ec0944959de3c/zpython.patch"}
  end unless build.head?

  def install
    args = %W[
      --disable-gdbm
      --enable-zpython
    ]

    system "autoreconf"
    system "./configure", *args

    # Disable building docs due to exotic yodl dependency
    inreplace "Makefile", "subdir in Src Doc;", "subdir in Src;"

    system "make"
    (lib/"zpython/zsh").install "Src/Modules/zpython.so"
  end

  def test
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
