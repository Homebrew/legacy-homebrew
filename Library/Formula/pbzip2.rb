require 'formula'

class Pbzip2 < Formula
  homepage 'http://compression.ca/pbzip2/'
  url 'http://compression.ca/pbzip2/pbzip2-1.1.8.tar.gz'
  sha1 '6957483690f00c33ffeabbe0e9e6475098820cd5'

  fails_with :llvm do
    build 2334
  end

  def install
    inreplace "Makefile", "$(PREFIX)/man", "$(PREFIX)/share/man"

    system "make", "PREFIX=#{prefix}",
                   "CC=#{ENV.cxx}",
                   "CFLAGS=#{ENV.cflags}",
                   "PREFIX=#{prefix}",
                   "install"
  end
end
