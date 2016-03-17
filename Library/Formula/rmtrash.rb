class Rmtrash < Formula
  desc "Move files to OS X's Trash"
  homepage "http://www.nightproductions.net/cli.htm"
  url "http://www.nightproductions.net/downloads/rmtrash_source.tar.gz"
  version "0.3.3"
  sha256 "9b30561454529e5923ffb62327d3fe009d23495263efc958534ac6b637e361d6"

  bottle do
    cellar :any
    sha256 "69021cde0c9835adda114798d90f1aaffb4ce1fff0204146ca1fc8afe7cb2960" => :yosemite
    sha256 "319c82f0b70f6444962afeede525f57e028f3594500b55434b1903648b828b7d" => :mavericks
    sha256 "45792bb368e03a9dbeea93e899b9d6b4aaeaba3d6b43face2cc00c3fba2babf6" => :mountain_lion
  end

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
