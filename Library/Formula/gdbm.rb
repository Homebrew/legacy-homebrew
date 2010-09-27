require 'formula'

class Gdbm <Formula
  url 'ftp://ftp.gnu.org/gnu/gdbm/gdbm-1.8.3.tar.gz'
  homepage 'http://www.gnu.org/software/gdbm/'
  md5 '1d1b1d5c0245b1c00aff92da751e9aa1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}", "--infodir=#{info}"
    inreplace "Makefile", "-o $(BINOWN) -g $(BINGRP)", ""
    system "make install"
  end
end
