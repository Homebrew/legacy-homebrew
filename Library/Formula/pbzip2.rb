require 'formula'

class Pbzip2 < Formula
  homepage 'http://compression.ca/pbzip2/'
  url 'http://compression.ca/pbzip2/pbzip2-1.1.6.tar.gz'
  md5 '26cc5a0d882198f106e75101ff0544a3'

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
