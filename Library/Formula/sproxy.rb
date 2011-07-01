require 'formula'

class Sproxy < Formula
  url 'ftp://sid.joedog.org/pub/sproxy/sproxy-1.01.tar.gz'
  homepage 'http://www.joedog.org/index/sproxy-home'
  md5 'a8c3fa4c67b3e842fe5ee2ade69a3653'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
    # Makefile doesn't honor mandir, so move it
    share.install prefix+"man"
  end
end
