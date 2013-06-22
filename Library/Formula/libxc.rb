require 'formula'

class Libxc < Formula
  homepage 'http://www.tddft.org/programs/octopus/wiki/index.php/Libxc'
  url 'http://www.tddft.org/programs/octopus/down.php?file=libxc/libxc-2.0.1.tar.gz'
  sha1 'f87a83fd1fbc2595902bef9c0f957ef3b00fef31'

  def install
    ENV.fortran
    system "./configure", "FCCPP=#{ENV.cc} -E -C -ansi",
           "CC=#{ENV.cc}", "CFLAGS=-pipe",
           "--prefix=#{prefix}", "--enable-shared"
    system "make"
    system "make install"
  end
end
