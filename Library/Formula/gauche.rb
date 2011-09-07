require 'formula'

class Gauche < Formula
  url 'http://downloads.sourceforge.net/gauche/Gauche/Gauche-0.9.2.tgz'
  homepage 'http://practical-scheme.net/gauche/'
  md5 '9979de5be0e35e57131508c4c606f5cb'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-multibyte=utf-8"
    system "make"
    system "make check"
    system "make install"
  end
end
