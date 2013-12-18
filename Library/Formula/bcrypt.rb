require 'formula'

class Bcrypt < Formula
  homepage 'http://bcrypt.sourceforge.net'
  url 'http://bcrypt.sourceforge.net/bcrypt-1.1.tar.gz'
  sha1 'fd4c7c83fdc560f143bb0e0a8c9fb7aa57e69698'

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=-lz"
    bin.install "bcrypt"
    man1.install gzip("bcrypt.1")
  end
end
