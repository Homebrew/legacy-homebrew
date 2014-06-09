require 'formula'

class Libxc < Formula
  homepage 'http://www.tddft.org/programs/octopus/wiki/index.php/Libxc'
  url 'http://www.tddft.org/programs/octopus/down.php?file=libxc/libxc-2.2.0.tar.gz'
  sha1 '77c3ffe2c664339f3eafbf7642ddeba482b88074'

  depends_on :fortran

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "FCCPP=#{ENV.fc} -E -x c",
                          "CC=#{ENV.cc}",
                          "CFLAGS=-pipe"
    system "make"
    system "make install"
  end
end
