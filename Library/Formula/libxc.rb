require 'formula'

class Libxc < Formula
  homepage 'http://www.tddft.org/programs/octopus/wiki/index.php/Libxc'
  url 'http://www.tddft.org/programs/octopus/down.php?file=libxc/libxc-1.1.0.tar.gz'
  md5 '208473eab66b096eb43355023baab5a0'

  def install
    ENV.fortran
    system "./configure", "FCCPP=clang -E -C -ansi", "CC=gcc",
           "CFLAGS=-O2 -pipe",
           "--prefix=#{prefix}"
    system "make install"
  end
end
