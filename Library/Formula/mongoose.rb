require 'formula'

class Mongoose < Formula
  homepage 'https://github.com/valenok/mongoose'
  url 'https://github.com/valenok/mongoose/tarball/3.4'
  sha1 '3b917304d5ffbb516167ef29561a9f82881bc033'

  def install
    system "make", "mac", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "mongoose"
    man1.install "mongoose.1"
  end
end
