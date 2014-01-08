require 'formula'

class Fio < Formula
  homepage 'http://freecode.com/projects/fio'
  url 'http://brick.kernel.dk/snaps/fio-2.0.15.tar.bz2'
  sha1 '3b672f19ef37d0f4d733dc78820a5e4a735b9a7f'

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
