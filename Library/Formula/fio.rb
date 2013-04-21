require 'formula'

class Fio < Formula
  homepage 'http://freecode.com/projects/fio'
  url 'http://brick.kernel.dk/snaps/fio-2.0.15.tar.bz2'
  sha1 '3b672f19ef37d0f4d733dc78820a5e4a735b9a7f'

  def install
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end
end
