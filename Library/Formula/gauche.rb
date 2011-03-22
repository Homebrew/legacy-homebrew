require 'formula'

class Gauche < Formula
  url 'http://downloads.sourceforge.net/gauche/Gauche/Gauche-0.9.1.tgz'
  homepage 'http://practical-scheme.net/gauche/'
  md5 '6134e9c16aef2bc9fd3fa7e8fbebdd10'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-multibyte=utf-8"
    system "make"
    system "make check"
    system "make install"
  end
end
