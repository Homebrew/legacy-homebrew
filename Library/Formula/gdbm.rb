require 'formula'

class Gdbm < Formula
  url 'http://ftpmirror.gnu.org/gdbm/gdbm-1.10.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gdbm/gdbm-1.10.tar.gz'
  homepage 'http://www.gnu.org/software/gdbm/'
  md5 '88770493c2559dc80b561293e39d3570'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}", "--infodir=#{info}"
    inreplace "Makefile", "-o $(BINOWN) -g $(BINGRP)", ""
    system "make install"
  end
end
