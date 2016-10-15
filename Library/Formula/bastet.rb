require 'formula'

class Bastet < Formula
  homepage 'http://fph.altervista.org/prog/bastet.html'
  url 'http://fph.altervista.org/prog/files/bastet-0.41.tgz'
  sha1 '644a0f76adedef84946159520c1639ff0c6c47ec'

  def patches
    # allows bastet to work on OS X
    'http://fph.altervista.org/prog/files/bastet-0.41-osx-patch.diff'
  end

  def install
    inreplace "Makefile", "BIN_PREFIX=/usr/bin/", "BIN_PREFIX=#{bin}/"
    inreplace "Makefile", "DATA_PREFIX=/var/games/", "DATA_PREFIX=#{var}/"
    inreplace "Makefile", "GAME_USER=games", "GAME_USER=`whoami`"
    system "make", "all"

    # for some reason, these aren't created automatically
    bin.mkpath
    var.mkpath
    man6.mkpath

    system "make", "install"

    # the makefile doesn't install the manpage
    man6.install 'bastet.6'
  end

  test do
    system "true" # since bastet doesn't provide any options, there is no way to perform a non-blocking test.
  end
end
