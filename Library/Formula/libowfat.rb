require 'formula'

class Libowfat < Formula
  url 'http://dl.fefe.de/libowfat-0.29.tar.bz2'
  head 'cvs://:pserver:cvs:@cvs.fefe.de:/cvs:libowfat'
  sha1 'f944ebac326f4a8bd1437ff995d0b8201280434c'
  homepage 'http://www.fefe.de/libowfat/'

  def install
    system "make", "libowfat.a"
    system "make", "install", "prefix=#{prefix}", "MAN3DIR=#{man3}", "INCLUDEDIR=#{include}/libowfat"
  end
end
