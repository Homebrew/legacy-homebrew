require 'formula'

class Fio < Formula
  homepage 'http://freecode.com/projects/fio'
  url 'http://brick.kernel.dk/snaps/fio-2.1.10.tar.bz2'
  sha1 '7a528340d6d1f3700fc07f10d3ac42c8a1d5ea7b'

  def install
    system "./configure"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end
end
