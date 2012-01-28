require 'formula'

class Cc65 < Formula
  url 'ftp://ftp.musoftware.de/pub/uz/cc65/cc65-sources-2.13.2.tar.bz2'
  homepage 'http://www.cc65.org/'
  md5 'cbf9e25db21002371222ae025a6a1850'

  def skip_clean? path
    true
  end

  def install
    ENV.deparallelize
    ENV.no_optimization
    system "make -f make/gcc.mak prefix=#{prefix}"
    system "make -f make/gcc.mak install prefix=#{prefix}"
  end
end
