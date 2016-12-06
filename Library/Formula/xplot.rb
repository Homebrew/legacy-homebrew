require 'formula'

class Xplot < Formula
  homepage 'http://www.xplot.org'
  url 'http://www.xplot.org/xplot/xplot-0.90.7.1.tar.gz'
  sha1 '164074206addaeb971d2fa65069c7c7be654efc5'

  depends_on :x11

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    inreplace 'Makefile', 'man/man1', 'share/man/man1'
    system "make install"
  end
end
