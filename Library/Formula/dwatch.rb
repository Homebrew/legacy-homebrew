require 'formula'

class Dwatch < Formula
  homepage 'http://siag.nu/dwatch/'
  url 'http://siag.nu/pub/dwatch/dwatch-0.1.1.tar.gz'
  md5 '25c06240cb5ab8126badc8a78dcd2b79'

  def install
    bin.mkpath  # Makefile uses cp, not install
    man1.mkpath # ditto

    system "make install CC=#{ENV.cc} PREFIX=#{prefix} MANDIR=#{man} ETCDIR=#{etc}"
    etc.install "dwatch.conf"
  end

  def test
    system "dwatch -h" # not that it HAS -h. bitches, but exits 0
  end
end
