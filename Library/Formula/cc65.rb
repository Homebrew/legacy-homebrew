require 'formula'

class Cc65 < Formula
  homepage 'http://www.cc65.org/'
  url 'ftp://ftp.musoftware.de/pub/uz/cc65/cc65-sources-2.13.3.tar.bz2'
  sha1 '925c6edfcef7057e24ecb0704fa07210faec07bc'

  head 'svn://svn.cc65.org/cc65/trunk'

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
