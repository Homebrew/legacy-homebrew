require 'formula'

class Dwatch < Formula
  homepage 'http://siag.nu/dwatch/'
  url 'http://siag.nu/pub/dwatch/dwatch-0.1.1.tar.gz'
  md5 '25c06240cb5ab8126badc8a78dcd2b79'

  def install
    # Makefile uses cp, not install
    bin.mkpath
    man1.mkpath

    system "make", "install",
                   "CC=#{ENV.cc}",
                   "PREFIX=#{prefix}",
                   "MANDIR=#{man}",
                   "ETCDIR=#{etc}"

    etc.install "dwatch.conf"
  end

  def test
    # '-h' is not actually an option, but it exits 0
    system "#{bin}/dwatch -h"
  end
end
