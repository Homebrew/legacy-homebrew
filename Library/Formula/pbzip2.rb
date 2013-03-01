require 'formula'

class Pbzip2 < Formula
  homepage 'http://compression.ca/pbzip2/'
  url 'http://compression.ca/pbzip2/pbzip2-1.1.6.tar.gz'
  sha1 '3b4d0ffa3ac362c3702793cc5d9e61664d468aeb'

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
