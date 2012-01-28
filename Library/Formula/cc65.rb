require 'formula'

class Cc65 < Formula
  url 'ftp://ftp.musoftware.de/pub/uz/cc65/cc65-sources-2.13.2.tar.bz2'
  homepage 'http://www.cc65.org/'
  md5 'cbf9e25db21002371222ae025a6a1850'

  head 'svn://svn.cc65.org/cc65/trunk'

  skip_clean :all

  def install
    ENV.deparallelize
    ENV.no_optimization
    system "make", "-f", "make/gcc.mak", "prefix=#{prefix}", "libdir=#{share}"
    system "make", "-f", "make/gcc.mak", "install", "prefix=#{prefix}", "libdir=#{share}"
  end

  def caveats; <<-EOS.undent
    Library files have been installed to:
      #{share}/cc65
    EOS
  end
end
