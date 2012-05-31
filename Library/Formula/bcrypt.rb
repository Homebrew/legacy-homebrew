require 'formula'

class Bcrypt < Formula
  url 'http://bcrypt.sourceforge.net/bcrypt-1.1.tar.gz'
  homepage 'http://bcrypt.sourceforge.net'
  md5 '8ce2873836ccd433329c8df0e37e298c'

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=-lz"
    bin.install "bcrypt"
    man1.install gzip("bcrypt.1")
  end
end
