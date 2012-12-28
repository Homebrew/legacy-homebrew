require 'formula'

class Mongoose < Formula
  homepage 'https://github.com/valenok/mongoose'
  url 'https://github.com/valenok/mongoose/tarball/3.3'
  sha1 '75800b5046dbfaf29b29d977346df22bcce674c0'

  def install
    system "make", "mac", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "mongoose"
    man1.install "mongoose.1"
  end
end
