require "formula"

class Fio < Formula
  homepage "http://freecode.com/projects/fio"
  url "http://brick.kernel.dk/snaps/fio-2.1.11.tar.bz2"
  sha1 "3a9e82477f29155fab531cb9d527469fef85042b"

  def install
    system "./configure"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "sharedir=#{share}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end
end
