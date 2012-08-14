require 'formula'

class Fio < Formula
  homepage 'http://freecode.com/projects/fio'
  url 'http://brick.kernel.dk/snaps/fio-2.0.7.tar.bz2'
  sha1 '597cca3a5843daeb3584ce52d090c58ca6632ef7'

  def install
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end
end
