require 'formula'

class Fio < Formula
  homepage 'http://freshmeat.net/projects/fio/'
  url 'http://brick.kernel.dk/snaps/fio-1.58.tar.bz2'
  md5 'bc5600997788bce5647576a4976d461d'

  def install
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end
end
