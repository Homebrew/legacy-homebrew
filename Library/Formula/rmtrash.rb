class Rmtrash < Formula
  homepage "http://www.nightproductions.net/cli.htm"
  url "http://www.nightproductions.net/downloads/rmtrash_source.tar.gz"
  sha256 "9b30561454529e5923ffb62327d3fe009d23495263efc958534ac6b637e361d6"
  version "0.3.3"

  def install
    # don't install as root
    inreplace "Makefile", "-o root -g wheel", ""
    # install manpages under share/man/
    inreplace "Makefile", "${DESTDIR}/man", "${DESTDIR}/share/man"

    bin.mkpath
    man1.mkpath

    system "make", "CC=#{ENV.cc}", "LDFLAGS=-framework Foundation -prebind"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system "#{bin}/rmtrash", "-h"
  end
end
