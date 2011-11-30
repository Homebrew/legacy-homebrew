require 'formula'

class Gdbm < Formula
  url 'http://ftpmirror.gnu.org/gdbm/gdbm-1.9.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gdbm/gdbm-1.9.1.tar.gz'
  homepage 'http://www.gnu.org/software/gdbm/'
  md5 '59f6e4c4193cb875964ffbe8aa384b58'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}", "--infodir=#{info}"
    inreplace "Makefile", "-o $(BINOWN) -g $(BINGRP)", ""
    system "make install"
  end
end
